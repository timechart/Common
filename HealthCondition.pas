unit HealthCondition;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, Menus, IdBaseComponent,
  IdIntercept, IdInterceptThrottler;

type
  TFrmHealthCondition = class(TForm)
    pnlHealthCondition: TPanel;
    pgcHealthCond: TPageControl;
    tabStudent: TTabSheet;
    lblStudent: TLabel;
    btnSaveStudentHealth: TBitBtn;
    cboStudent: TComboBox;
    tabHealthCond: TTabSheet;
    lblHealthCondName: TLabel;
    lblHealthDescription: TLabel;
    lblConditionWebLink: TLabel;
    memHealthDescription: TMemo;
    cboHealthCondName: TComboBox;
    btnCancel: TBitBtn;
    memStudentHealthNote: TMemo;
    lblNoteToAssist: TLabel;
    lblAllConditions: TLabel;
    popHealthCond: TPopupMenu;
    PopHealtCondRemove: TMenuItem;
    popHealthCondMoreDetails: TMenuItem;
    btnAddCondition: TButton;
    lblConditionWebURL: TLabel;
    chkHealthSupportPlan: TCheckBox;
    edtKeySupportPerson: TEdit;
    edtOtherRelevanInfo: TEdit;
    edtEmergencyContact: TEdit;
    lblKeySupportPerson: TLabel;
    lblEmergencyContact: TLabel;
    lblOtherRelevanInfo: TLabel;
    edtEmergencyContactNo: TEdit;
    Label1: TLabel;
    tabPeerSupportGroup: TTabSheet;
    cboPeerSupportGroups: TComboBox;
    lblPeerSupportGroups: TLabel;
    lsvPeerSupportGroup: TListView;
    N1: TMenuItem;
    popHCAddtoPeerSupportGroup: TMenuItem;
    lsvStudentHealthCond: TListView;
    popHCRemovefromPeersupportGrooup: TMenuItem;
    btnCreateHealthCondtion: TButton;
    procedure FormShow(Sender: TObject);
    procedure RefreshHealthConditionDetails(Sender: TObject);
    procedure LinkToWebPage(Sender: TObject);
    procedure SaveStudentHealthConditions(Sender: TObject);
    procedure RemoveStudentHealthCondition(Sender: TObject);
    procedure DisplayMoreDetails(Sender: TObject);
    procedure AddHealthConditionToStudent(Sender: TObject);
    procedure RefreshStudentHealthConditions(Sender: TObject);
    procedure RefreshNote(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AddToPeerSupportGroup(Sender: TObject);
    procedure RefreshStudentsInPeerSupportGroup(Sender: TObject);
    procedure RefreshPeerSupportGroup(Sender: TObject);
    procedure RemoveFromPeerSupportGroup(Sender: TObject);
    procedure SetupMenu(Sender: TObject);
    procedure DisplayCreateHealthCondition(Sender: TObject);
  private
    FStudentNo: Integer;
    FConditions: TStringList;
    FHasAccess: Boolean;
    function RefreshStudents: Boolean;
    function GetStudentIndexByNo(const pStudNo: Integer): Integer;
    function GetCondNameByCode(const pCode: string): string;
    procedure LoadHealthConditions;
    procedure EnableControls(const pEnable: Boolean);
    procedure EditStudentPeerSupportGroup(const pEnable: Boolean);
    procedure RefreshHealthConditions;
    procedure SetUserAccess;
  public
    property StudentNo: Integer read FStudentNo write FStudentNo;
    property HasAccess: Boolean read FHasAccess write FHasAccess default True;
  end;

var
  FrmHealthCondition: TFrmHealthCondition;

implementation

uses
  uAMGHealthCondition, TimeChartGlobals, uAMGStudent, uAMGConst, EditHealthCondition,
  ShellAPI, uAMGCommon, CreateHealthCondition;

{$R *.dfm}

procedure TFrmHealthCondition.AddHealthConditionToStudent(Sender: TObject);
var
  lStudCode: string;
  lIssueCode: string;
  lStudentHealthCondition: TAMGStudentHealthCondition;
  lListItem: TListItem;
  lFrmEditHealthCondition: TFrmEditHealthCondition;
  lIdx: Integer;
  function GetIndexOfSHI(const pStudCode, pIssueCode: string): Integer;
  var
    i: Integer;
    lStudentHealtCondition: TAMGStudentHealthCondition;
  begin
    Result := -1;
    for i := 0 to lsvStudentHealthCond.Items.Count - 1 do
    begin
      lStudentHealthCondition := TAMGStudentHealthCondition(lsvStudentHealthCond.Items[i].Data);
      if (lStudentHealthCondition.StudentCode = pStudCode) and (lStudentHealthCondition.HealthConditionCode = pIssueCode) then
      begin
        Result := i;
        Break;
      end;
    end;
  end;

begin
  if cboStudent.ItemIndex >= 0 then
  begin
    lStudCode := TAMGStudent(cboStudent.Items.Objects[cboStudent.ItemIndex]).Code;
    if Trim(lStudCode) = '' then
      MessageDlg(AMG_STUDENTID_NOT_PROVIDED, mtInformation, [mbOk], 0)
    else
    begin
      lFrmEditHealthCondition := TFrmEditHealthCondition.Create(Application);
      try
        if lFrmEditHealthCondition.ShowModal = mrOk then
        begin
          lIssueCode := lFrmEditHealthCondition.HealthCondition.Code;
          lIdx := GetIndexOfSHI(lStudCode, lIssueCode);
          if lIdx = -1 then
          begin
            lStudentHealthCondition := TAMGStudentHealthCondition.Create;
            lStudentHealthCondition.StudentCode := lStudCode;
            lStudentHealthCondition.HealthConditionCode := lIssueCode;
            lStudentHealthCondition.HealthConditionID := lFrmEditHealthCondition.HealthCondition.ID;
            lStudentHealthCondition.StudentHealthNote := lFrmEditHealthCondition.HealthNote;
            lListItem := lsvStudentHealthCond.Items.Add;
            lListItem.Caption := GetCondNameByCode(lIssueCode);
            lListItem.SubItems.Add(BoolToStr(lStudentHealthCondition.IsInPeerSupport, True));
            lListItem.Data := Pointer(lStudentHealthCondition);
            lListItem.Selected := True;
            lListItem.Focused := True;
            if lsvStudentHealthCond.Visible and lsvStudentHealthCond.Enabled then
              lsvStudentHealthCond.SetFocus;
            StudentHealthConditions.Add(lStudentHealthCondition);
          end
          else
          begin
            lIdx := StudentHealthConditions.GetIssueIndex(lStudCode, lIssueCode);
            TAMGStudentHealthCondition(StudentHealthConditions.Items[lIdx]).StudentHealthNote := lFrmEditHealthCondition.HealthNote;
          end;
          EnableControls(True);
          memStudentHealthNote.Lines.Text := lFrmEditHealthCondition.HealthNote;
        end;
      finally
        FreeAndNil(lFrmEditHealthCondition);
      end;
    end;
  end;
end;

procedure TFrmHealthCondition.AddToPeerSupportGroup(Sender: TObject);
begin
  EditStudentPeerSupportGroup(True);
end;

procedure TFrmHealthCondition.DisplayCreateHealthCondition(Sender: TObject);
var
  lFrmAddHealthCondition: TFrmAddHealthCondition;
begin
  lFrmAddHealthCondition := TFrmAddHealthCondition.Create(Application);
  try
    if lFrmAddHealthCondition.ShowModal = mrOK then
      RefreshHealthConditions;
  finally
    FreeAndNil(lFrmAddHealthCondition);
  end;
end;

procedure TFrmHealthCondition.DisplayMoreDetails(Sender: TObject);
var
  lHealthConditionCode: string;
  i: Integer;
begin
  lHealthConditionCode := TAMGStudentHealthCondition(lsvStudentHealthCond.Selected.Data).HealthConditionCode;
  for i := 0 to cboHealthCondName.Items.Count - 1 do
  begin
    if TAMGHealthCondition(cboHealthCondName.Items.Objects[i]).Code = lHealthConditionCode then
    begin
      cboHealthCondName.ItemIndex := i;
      RefreshHealthConditionDetails(Self);
      pgcHealthCond.ActivePage := tabHealthCond;
      Break;
    end;
  end;
end;

procedure TFrmHealthCondition.EditStudentPeerSupportGroup(const pEnable: Boolean);
var
  lStudentHealthCondition: TAMGStudentHealthCondition;
  i: Integer;
begin
  lStudentHealthCondition := TAMGStudentHealthCondition(lsvStudentHealthCond.Selected.Data);
  lStudentHealthCondition.IsInPeerSupport := pEnable;
  lsvStudentHealthCond.Selected.SubItems[0] := BoolToStr(lStudentHealthCondition.IsInPeerSupport, True);
end;

procedure TFrmHealthCondition.EnableControls(const pEnable: Boolean);
begin
  if FHasAccess then
  begin
    memStudentHealthNote.Enabled := pEnable;
    chkHealthSupportPlan.Enabled := pEnable;
    edtKeySupportPerson.Enabled := pEnable;
    edtEmergencyContact.Enabled := pEnable;
    edtEmergencyContactNo.Enabled := pEnable;
    edtOtherRelevanInfo.Enabled := pEnable;
    btnSaveStudentHealth.Enabled := pEnable;
  end;
end;

procedure TFrmHealthCondition.FormCreate(Sender: TObject);
begin
  FStudentNo := -1;
  FConditions := TStringList.Create;
end;

procedure TFrmHealthCondition.FormDestroy(Sender: TObject);
begin
  if Assigned(FConditions) then
    FreeAndNil(FConditions);
end;

procedure TFrmHealthCondition.FormShow(Sender: TObject);
begin
  EnableControls(False);
  RefreshHealthConditions;
  RefreshStudents;
  lsvStudentHealthCond.Color := clRelevantControlOnDlg;
  lsvPeerSupportGroup.Color := clRelevantControlOnDlg;
  SetUserAccess;
end;

function TFrmHealthCondition.GetCondNameByCode(const pCode: string): string;
var
  i: Integer;
  lHealthCondition: TAMGHealthCondition;
begin
  for i := 0 to HealthConditions.Count - 1 do
  begin
    lHealthCondition := TAMGHealthCondition(HealthConditions.Items[i]);
    if lHealthCondition.Code = pCode then
    begin
      Result := lHealthCondition.ConditionName;
      Break;
    end;
  end;
end;

function TFrmHealthCondition.GetStudentIndexByNo(const pStudNo: Integer): Integer;
var
  i : Integer;
begin
  Result := -1;
  for i := 0 to cboStudent.Items.Count -1 do
  begin
    if TAMGStudent(cboStudent.Items.Objects[i]).ID = pStudNo then
    begin
      Result := i;
      Break;
    end;
  end;
end;

procedure TFrmHealthCondition.LinkToWebPage(Sender: TObject);
begin
  ShellExecute(Handle, nil, PChar(lblConditionWebURL.Caption), nil, nil, SW_SHOWNORMAL);
  Application.ProcessMessages;
end;

procedure TFrmHealthCondition.LoadHealthConditions;
var
  lHealthCond: TAMGHealthCondition;
  i: Integer;

  procedure InsertHealthCondition(const pName, pDescription, pURL: string);
  begin
    lHealthCond := TAMGHealthCondition.Create;
    lHealthCond.ConditionName := pName;
    lHealthCond.ConditionDescription := pDescription;
    lHealthCond.Code := lHealthCond.GetHealthConditionCode;
    lHealthCond.ConditionWebURL := pURL;
    HealthConditions.Add(lHealthCond);
  end;
begin
  HealthConditions.Clear;
  InsertHealthCondition('Acquired Brain Injury (ABI)',
                        '"Acquired brain injury (ABI) is injury to the brain, which results in deterioration in cognitive, physical, sensory, emotional or independent functioning. ABI can occur as a result of trauma, hypoxia ' + '(where a person has less than the normal level of oxygen in the body), infection, tumour, substance abuse, degenerative neurological diseases or stroke.' + #10#13 +
                        'These impairments to cognitive abilities or physical functioning may be temporary or permanent and cause partial or total disability or psychosocial difficulty. The term "acquired brain injury" ' + 'is used to describe all types of brain injury, including traumatic brain injury (TBI), ' + 'which occurs as result of a blow to the head in for example a car accident, fall or assault."',
                        'http://www.chronicillness.org.au/invisible/abi_a.htm');

  InsertHealthCondition('Anaphylaxis',
                        'Anaphylaxis is the most severe form of allergic reaction and is potentially life threatening. It must be treated as a medical emergency, requiring immediate treatment and urgent medical attention.' +
                        'Anaphylaxis is a generalised allergic reaction, which often involves more than one body system (e.g. skin, respiratory, gastro-intestinal, cardiovascular). A severe allergic reaction usually occurs within 20 minutes ' + 'of exposure to the trigger and can rapidly become life threatening.',
                        'http://www.allergyfacts.org.au/');

  InsertHealthCondition('Asthma',
                        'Asthma affects up to one in nine children and one in ten adults. It is important for school staff to be aware of asthma, its symptoms and triggers and most importantly, the management of asthma in the school environment.' + #10#13 +
                        'Asthma is a condition that affects the airways of the lungs. In a person with asthma, the airways are more sensitive than normal. When they are exposed to a ‘trigger’ they overreact and narrow, resulting in an asthma attack. The narrowing is caused by:' + #10#13 +
                        '' + #10#13 +
                        '    * constriction of the muscle in the walls of the airways' + #10#13 +
                        '    * swelling of the lining layer of the airways' + #10#13 +
                        '    * excessive production of mucus in the airways.' + #10#13 +
                        '' + #10#13 +
                        'A variety of triggers may lead to an asthma attack (for example, colds/flu, exercise, pollens, dust, dust mite, temperature change or smoke) and these triggers vary from person to person.',
                        'http://www.chronicillness.org.au/invisible/asthma_a.htm');

  InsertHealthCondition('Cancer',
                        'In general, cancer occurs when cells in the body multiply in an uncontrolled way. As their numbers increase, they form a mass that affects the normal functioning of the surrounding tissue. If cancer is not successfully treated at ' + 'this stage, cancer cells can break away and spread through the bloodstream or lymphatic system to other parts of the body. This process is called metastasis. If a cancer metastasises it can be very difficult to treat or cure.' + #10#13 +
                        '' + #10#13 +
                        'The cells in almost any part of the body can become cancerous. Cancers in children and young people are quite different from cancers affecting adults. They usually affect different parts of the body and the cancerous cells look ' + 'different under a microscope. They are often treated with the same types of treatments but they respond differently, sometimes much better.' + #10#13 +
                        '' + #10#13 +
                        'How common is childhood cancer?' + #10#13 +
                        '' + #10#13 +
                        'Childhood cancer is much less common than adult cancers.  In Australia about 500 children are diagnosed with cancer every year. Although this is significant, it is fewer in comparison with approximately 88,000 adults diagnosed with cancer each year.   ' + 'Cure rates for children are much higher than for most adult cancers with over 70% of all children now being cured.  The figure can be as high as 90% for certain types.' + #10#13 +
                        '' + #10#13 +
                        'What causes childhood cancer?' + #10#13 +
                        '' + #10#13 +
                        'Cancer is caused by a disruption to a cell''s genes. In many adult cancers, this is clearly due to a carcinogen (an agent that causes cancer, like ultraviolet radiation or some of the substances in cigarettes). In most childhood cancers, the factors ' + 'that cause cells'' genes to become abnormal have ' + 'not been identified. Certain medical conditions, rare inherited disorders, exposure ' + 'to radiation and previous cancer treatments have been linked to cancer, but the causes of most childhood cancers are not known.  Scientists ' + 'continue to study lifestyle and environmental factors in their search for a cause, but as yet have found none. We do know that cancer is NOT contagious.  It cannot be passed from one person to another.' + #10#13 +
                        '' + #10#13 +
                        'Cancer clusters' + #10#13 +
                        '' + #10#13 +
                        'Although it is rare, two or three children/young people from the same school or community may develop cancer.  This raises concerns that something in the local environment may be causing the cancer. When several people in one ' + 'area develop cancer it is known as a ‘cancer cluster’.  ' + 'Cancer clusters are taken very seriously and investigated thoroughly.  But usually it turns out that it is a coincidence ' + 'rather than being caused by a particular environmental or chemical change.',
                        'http://www.chronicillness.org.au/invisible/cancer_a.htm');

  InsertHealthCondition('Chronic Fatigue Syndrome (ME/CFS)',
                        'ME/CFS (Myalgic Encephalomyelitis/Chronic Fatigue Syndrome) is a complex illness that affects many parts of the body, particularly the nervous, immune and endocrine (hormonal) systems. It can cause marked disruption to all aspects of a child’s life.' + #10#13 +
                        '' + #10#13 +
                        'Every child is affected differently, depending on their particular combination of symptoms and the overall severity of their condition.',
                        'http://www.chronicillness.org.au/invisible/me-cfs_a.htm');

  InsertHealthCondition('Cystic Fibrosis',
                        'Cystic Fibrosis (CF) is the most common inherited life-shortening condition affecting Australians. When someone has CF, his or her cells are missing an essential protein so that chloride and sodium can not be properly ' + 'transported across the cell membrane. This cellular defect affects the body in many significant ways. In the lungs, mucus secretions are thicker, ' +
                        'stickier and hard to move. Blockages in the airways trap bacteria, causing repeated lung infections and localised inflammation that eventually produces scarring and irreversible damage to the lungs. Respiratory failure is the major cause of ' + 'premature death. CF also directly affects the pancreatic and gastrointestinal systems. Around 90% of people with CF need to ' + 'consume enzyme capsules when eating. This is because the pancreas is unable to produce sufficient enzymes to digest food. ' + 'Furthermore, thickened secretions block the pancreatic duct, meaning that naturally occurring enzymes can not reach ' + 'the small intestine to break down food so that nutrients can be absorbed. CF can also affect the sinuses, liver, spleen and ' + 'reproductive systems.  Around 95% of males with CF are sterile as they either do not have or experience shrinkage of ' +
                        'the vas deferens (the tubes which carry sperm from the testes to the ejaculatory ducts). However, the existence of sperm in the testes' + ' means that many are able to father children using IVF techniques. Women with CF may also have reduced fertility but in most instances can conceive naturally.',
                        'http://www.chronicillness.org.au/invisible/cf_a.htm');

  InsertHealthCondition('Diabetes',
                        'Around one in 700 Australian children has diabetes. Diabetes is an endocrine disorder where the body is unable to use blood sugar (glucose). Type 1 diabetes usually occurs in childhood and young adulthood, although it can occur at any age. Most ' + 'children and young people with diabetes have Type 1 diabetes otherwise known as insulin dependent diabetes mellitus. In order to use glucose for energy the hormone insulin needs to be secreted by the pancreas. People with Type 1 diabetes or IDDM are ' + 'unable to produce insulin and require its replacement by injection. Type 1 diabetes is NOT caused by lifestyle factors.',
                        'http://www.chronicillness.org.au/invisible/diabetes_a.htm');

  InsertHealthCondition('Epilepsy',
                        'Epilepsy is the most common serious brain disorder in the world. Current estimates suggest that over 142,000 Victorians will have epilepsy before the age of 70 (approximately 3% of the population).' + #10#13 +
                        '' + #10#13 +
                        'Epilepsy is a tendency to have recurrent seizures. A seizure occurs as a result of a sudden, usually brief, excessive electrical discharge in a group of brain cells. Seizures can vary from person to person. A seizure can consist of any of the ' + 'following: a blank stare, tremors or jerks, a convulsion with a total loss of consciousness, strange feelings and sensations, unusual tastes, ' + 'lip-smacking and chewing, visual disturbances, aimless wandering, fiddling with clothes or objects. These behaviours and how they present all relate back to the area of the brain from which the seizure is originating.There are two main groups of ' + 'seizures - partial and generalised. Partial seizures start in one part of the brain and what happens to someone during a partial seizure will ' +
                        'depend on where the seizure occurs in the brain and what function that part of the brain controls. There are two types of partial seizures - simple partial & complex partial and the distinction between the two is important in a school setting.',
                        'http://www.chronicillness.org.au/invisible/epilepsy_a.htm');

  InsertHealthCondition('Haemophilia',
                        'Haemophilia is a rare blood clotting disorder caused by a deficiency of clotting factor in the blood. It affects males almost exclusively. Clotting factors are like dry ingredients in a cake-helping the cake set. Without enough, the cake will take ' + 'longer to set and will not have the desired result.' + #10#13 +
                        '' + #10#13 +
                        'When there is not enough of a particular factor in the blood, bleeding takes longer to heal. Scratches and cuts take a little more effort to stop bleeding. Internal bleeding, however, is the biggest problem. Bleeding can be triggered by surgery or ' + 'trauma, or, in people with severe haemophilia, it can happen for no apparent reason.' + #10#13 +
                        '' + #10#13 +
                        'Haemophilia A, or Classical Haemophilia, is a deficiency of blood clotting factor VIII. This is the most common form of haemophilia.' + #10#13 +
                        '' + #10#13 +
                        'Haemophilia B is also called Christmas disease, after the first patient in whom the disorder was discovered. Haemophilia B is caused by a factor IX deficiency.' + #10#13 +
                        '' + #10#13 +
                        'Although haemophilia A and B are caused by a deficiency of different clotting factors, symptoms are very similar. Haemophilia A and B are often referred to simply as ''haemophilia'' because the two disorders are similar.',
                        'http://www.chronicillness.org.au/invisible/haemophilia_a.htm');

  InsertHealthCondition('Hepatitis C',
                        'It is estimated that around 210,000 Australians currently live with the hepatitis C virus.' + #10#13 +
                        '' + #10#13 +
                        'Hepatitis C is a blood borne virus. It is one of several viruses that can cause inflammation of the liver. The virus was identified in 1989. Before that time it was called non-A/ non-B hepatitis It is a very slow-acting virus. Hepatitis C involves ' + 'an initial acute phase of infection that may not be noticeable, because in many cases people do not feel sick. A large percentage of people ' + 'infected with the virus will experience impaired quality of life. The variety and intensity of the symptoms vary widely. Many people will have ' + 'symptoms that are uncomfortable and significantly affect the quality of life, while others may not be as seriously affected. According to current estimates, only 3-5% of people infected may die through liver cancer or failure after 20 to 40+ ' + 'years of infection.' + #10#13 +
                        '' + #10#13 +
                        'The virus is transmitted through infected blood entering into another person’s blood stream. Risk transmission factors are related to activities that involve this type of contact such as: sharing injecting equipment, transfusion of blood products ' + 'before 1990 in Australia,  unsterile mass vaccination programmes in  many countries, non-sterile medical or dental procedures, non-sterile ' + 'tattooing and body-piercing, and other accidental exposures where infected blood can transfer from the bloodstream of one person to another. ' + 'The risk of transmission from mother to baby is relatively low (5%) while infection from a community needlestick injury is extremely rare.' + #10#13 +
                        '' + #10#13 +
                        'Symptoms may appear a long time after  infection to the virus (average of 10-20 years). Most common symptoms are bouts of extreme fatigue,  flu-like symptoms, night sweats, nausea/indigestion, depression/mood swings, loss of appetite, itching, ' + 'joint pain and pain in the liver region. Some people will present no symptoms, others will present some of the above symptoms but not ' + 'necessarily all of them. It is important to note that the experience of the infection varies widely and people who are diagnosed with the infection face much uncertainty about its impact. ' + 'Severity of symptoms are not necessarily related to the extent of liver damage.' + #10#13 +
                        '' + #10#13 +
                        'Complementary or alternative therapies, such as Traditional Chinese and Western Herbal Medicine are used by many people to assist with managing the symptoms of hepatitis C. Research on the effectiveness of these therapies is increasing with some ' + 'specific herbs being identified as having helpful properties.',
                        'http://www.chronicillness.org.au/invisible/hepc_a.htm');

  InsertHealthCondition('Slow Transit Constipation (STC)',
                        'Chronic constipation is a major problem in the general community, but is not commonly discussed and its prevalence is underestimated. Common constipation is when a child has hard faeces (stool) or does not go regularly.  There is a lot of difference ' + ' in the firmness and frequency of stool in normal children. Constipation is quite a common problem in children, but with improvement in bowel habits and appropriate use of medications, it can usually be controlled.' + #10#13 +
                        '' + #10#13 +
                        'However, there is a subgroup of children that present with slow transit constipation (STC), that have a functional abnormality because of disordered nerves and muscles of the colon itself.  Many children with STC have been found ' + 'by biopsy to have abnormalities of the neurotransmitters (messenger molecules in the nerves) in the muscular layers of the bowel wall.  In particular, they have a deficiency of Substance P, a peptide thought to be involved in the ' + 'activation of bowel contraction.  In these children, movement of stool within the colon is markedly delayed.  In kids with STC the stool often remains stored in the right or middle portion of the colon and does not progress adequately to the rectosigmoid ' + 'colon, causing a build up and discomfort.  It is the rectosigmoid colon that is responsible for the propulsion and transfer of stool (poo) out of the body.' + #10#13 +
                        '' + #10#13 +
                        'The symptoms of STC include long delays in the passage of stool, accompanied by lack of urgency to move the bowels.  It has been determined that the normal frequency of stool passage is three or more bowel movements per week, ' + 'however in children with STC often they do not pass a stool for 7-10 days at a time; at times longer.  Physically, many children with STC do not appear unwell.  Sometimes this can lead to inaccurate perception that their health problems ' + 'are not significant.  These children and their families can face considerable difficulties, with distressing symptoms and never-ending treatments.' + #10#13 +
                        '' + #10#13 +
                        'Many children who have been diagnosed with STC (and some other children with difficult to manage constipation and soiling) continue to have symptoms even with the best treatment available at present. They may have nausea, abdominal' + ' pain, poor appetite and soiling.  They often have had symptoms for some time and many frustrations associated with their poor response to treatments.  They may have had unpleasant treatment regimes.  The management may have involved ' + 'uncomfortable and potentially frightening procedures, including repeated enemas.  Treatments will often have included large doses of laxatives orally or by naso-gastric tube and many children will have had multiple hospital admissions for these ' + 'treatments.' + #10#13 +
                        '' + #10#13 +
                        'Despite the best efforts of health care providers and families, these children may feel different, depressed, angry and sometimes isolated and rejected.  Their self esteem is often low.  Some children have abdominal surgery, which ' + 'can improve their physical symptoms but may exacerbate their feelings of difference.  Children and young people need time to adjust to stomas or appliances and often feel self-conscious about their surgical incisions or scars.  The incidence ' + 'of behavioural and emotional problems in studies of children with constipation/soiling is high.' + #10#13 +
                        '' + #10#13 +
                        'There is no need for a routine abdominal X-ray to diagnose constipation.  A potentially more helpful test is a transit study.  This can be done with radio opaque markers and standard X-ray or in nuclear medicine with a radio ' + 'labelled drink.  The test measures movement of faeces through the bowel.  It can distinguish general colonic slowness (STC) from functional faecal retention in the rectum only.',
                        'http://www.chronicillness.org.au/invisible/stc_a.htm');

  InsertHealthCondition('Thyroid Conditions',
                        'The thyroid is a butterfly-shaped endocrine gland situated in the front part of the neck, just below the Adam’s apple. It produces two hormones which are essential for normal metabolism. There are a range of thyroid disorders that can afflict children.',
                        'http://www.chronicillness.org.au/invisible/thyroid_a.htm');
end;

procedure TFrmHealthCondition.RefreshHealthConditionDetails(Sender: TObject);
var
  lHealthCondition: TAMGHealthCondition;
begin
  if cboHealthCondName.ItemIndex >= 0 then
  begin
    lHealthCondition := TAMGHealthCondition(cboHealthCondName.Items.Objects[cboHealthCondName.ItemIndex]);
    memHealthDescription.Lines.Text := lHealthCondition.ConditionDescription;
    lblConditionWebURL.Caption := lHealthCondition.ConditionWebURL;
  end
  else
  begin
    memHealthDescription.Lines.Text := '';
    lblConditionWebURL.Caption := '';
  end;
end;

procedure TFrmHealthCondition.RefreshHealthConditions;
var
  i: Integer;
  lHealthCondition: TAMGHealthCondition;
begin
  HealthConditions.RefreshFromFile;
  StudentHealthConditions.RefreshFromFile;
  cboHealthCondName.Clear;
  cboPeerSupportGroups.Clear;
  if HealthConditions.Count = 0 then
    LoadHealthConditions;
  for i := 0 to HealthConditions.Count -1 do
  begin
    cboHealthCondName.AddItem(TAMGHealthCondition(HealthConditions.Items[i]).ConditionName, TAMGHealthCondition(HealthConditions.Items[i]));
    cboPeerSupportGroups.AddItem(TAMGHealthCondition(HealthConditions.Items[i]).ConditionName, TAMGHealthCondition(HealthConditions.Items[i]));
  end;

  cboHealthCondName.ItemIndex := 0;
  cboHealthCondName.OnChange(Self);
  cboPeerSupportGroups.ItemIndex := 0;
  RefreshStudentsInPeerSupportGroup(Self);
  pgcHealthCond.ActivePage := tabStudent;
end;

procedure TFrmHealthCondition.RefreshNote(Sender: TObject; Item: TListItem; Change: TItemChange);
var
  lStudentHealthCondition: TAMGStudentHealthCondition;
begin
  if lsvStudentHealthCond.ItemIndex >= 0 then
  begin
    if Assigned(lsvStudentHealthCond.Selected.Data) then
    begin
      lStudentHealthCondition := TAMGStudentHealthCondition(lsvStudentHealthCond.Selected.Data);
      memStudentHealthNote.Lines.Text := lStudentHealthCondition.StudentHealthNote;
    end;
  end;
end;

procedure TFrmHealthCondition.RefreshPeerSupportGroup(Sender: TObject);
begin
  if pgcHealthCond.ActivePage = tabPeerSupportGroup then
    RefreshStudentsInPeerSupportGroup(Self);
end;

procedure TFrmHealthCondition.RefreshStudentHealthConditions(Sender: TObject);
var
  lStudCode: string;
  i: Integer;
  lListItem: TListItem;
  lStudentHealthCondition: TAMGStudentHealthCondition;
  lFound: Boolean;
begin
  if cboStudent.ItemIndex >= 0 then
  begin
    lsvStudentHealthCond.Clear;
    memStudentHealthNote.Clear;
    chkHealthSupportPlan.Checked := False;
    edtKeySupportPerson.Text := '';
    edtEmergencyContact.Text := '';
    edtEmergencyContactNo.Text := '';
    edtOtherRelevanInfo.Text := '';
    lFound := False;
    lStudCode := TAMGStudent(cboStudent.Items.Objects[cboStudent.ItemIndex]).Code;
    for i := 0 to StudentHealthConditions.Count - 1 do
    begin
      lStudentHealthCondition := TAMGStudentHealthCondition(StudentHealthConditions.Items[i]);
      if lStudentHealthCondition.StudentCode = lStudCode then
      begin
        lListItem := lsvStudentHealthCond.Items.Add;
        lListItem.Caption := GetCondNameByCode(lStudentHealthCondition.HealthConditionCode);
        lListItem.SubItems.Add(BoolToStr(lStudentHealthCondition.IsInPeerSupport, True));
        lListItem.Data := Pointer(lStudentHealthCondition);

        chkHealthSupportPlan.Checked := lStudentHealthCondition.HasHealthSupportPlan;
        edtKeySupportPerson.Text := lStudentHealthCondition.KeySuportPerson;
        edtEmergencyContact.Text := lStudentHealthCondition.EmergencyContact;
        edtEmergencyContactNo.Text := lStudentHealthCondition.EmergencyContactNo;
        edtOtherRelevanInfo.Text := lStudentHealthCondition.OtherRelevantInfo;
        lFound := True;
      end;
    end;
    EnableControls(lFound);
    if lsvStudentHealthCond.Items.Count > 0 then
      lsvStudentHealthCond.ItemIndex := 0;
  end;
end;

function TFrmHealthCondition.RefreshStudents: Boolean;
var
  lStudNo: Integer;
  i: Integer;
  lStudID: string;
  lStudent: TAMGStudent;
begin
  for i := 0 to Students.Count - 1 do
  begin
    lStudent := TAMGStudent(Students.Items[i]);

    lStudID := Trim(lStudent.Code);
    if lStudID = '' then
      lStudID := AMG_ID_NOT_PROVIDED;

    cboStudent.AddItem(lStudent.StName + ' ' + lStudent.First + ' - ' + ShortGenderToDescription(lStudent.Sex) + ' (' + lStudID + ')', lStudent);
 end;
  if cboStudent.Items.Count > 0 then
  begin
    if FStudentNo >= 0 then
      cboStudent.ItemIndex := GetStudentIndexByNo(FStudentNo)
    else
      cboStudent.ItemIndex := 0;
    RefreshStudentHealthConditions(Self);
  end;
end;

procedure TFrmHealthCondition.RefreshStudentsInPeerSupportGroup(Sender: TObject);
var
  lHealthCondition: TAMGHealthCondition;
  i: Integer;
  lStudCode: string;
  lListItem: TListItem;
  lStudIdx: Integer;
  lStudent: TAMGStudent;
begin
  lsvPeerSupportGroup.Clear;
  if cboPeerSupportGroups.ItemIndex >= 0 then
  begin
    lHealthCondition := TAMGHealthCondition(cboPeerSupportGroups.Items.Objects[cboPeerSupportGroups.ItemIndex]);
    for i := 0 to StudentHealthConditions.Count - 1 do
    begin
      if (lHealthCondition.Code = TAMGStudentHealthCondition(StudentHealthConditions.Items[i]).HealthConditionCode) and
         (TAMGStudentHealthCondition(StudentHealthConditions.Items[i]).IsInPeerSupport) then
      begin
        lStudCode := TAMGStudentHealthCondition(StudentHealthConditions.Items[i]).StudentCode;
        lStudIdx := Students.IndexOf(lStudCode);
        if lStudIdx >= 0 then
        begin
          lStudent := TAMGStudent(Students.Items[lStudIdx]);

          lListItem := lsvPeerSupportGroup.Items.Add;
          lListItem.Caption := lStudent.StName + ' ' + lStudent.First;;
          lListItem.SubItems.Add(lStudent.Code);
          lListItem.SubItems.Add(lStudent.Sex);
          lListItem.SubItems.Add(YearName[lStudent.StudYear]);
          lListItem.SubItems.Add(ClassCode[lStudent.tcClass]);
          lListItem.SubItems.Add(TeName[lStudent.Home, 1]);
          lListItem.SubItems.Add(TeName[lStudent.Tutor, 0]);
        end; // if
      end; // if
    end; // for
  end;
end;

procedure TFrmHealthCondition.RemoveFromPeerSupportGroup(Sender: TObject);
begin
  EditStudentPeerSupportGroup(False);
end;

procedure TFrmHealthCondition.RemoveStudentHealthCondition(Sender: TObject);
var
  lStudentHealthCondition: TAMGStudentHealthCondition;
  lIdx: Integer;
begin
  lStudentHealthCondition := TAMGStudentHealthCondition(lsvStudentHealthCond.Items[lsvStudentHealthCond.ItemIndex].Data);
  lIdx := StudentHealthConditions.GetIssueIndex(lStudentHealthCondition.StudentCode, lStudentHealthCondition.HealthConditionCode);
  if lIdx >= 0 then
    StudentHealthConditions.Delete(lIdx);

  lsvStudentHealthCond.DeleteSelected;
  if lsvStudentHealthCond.Items.Count > 0 then
  begin
    lsvStudentHealthCond.Items[0].Selected := True;
    RefreshNote(nil, nil, ctText);
  end
  else
    memStudentHealthNote.Clear;
end;

procedure TFrmHealthCondition.SaveStudentHealthConditions(Sender: TObject);
var
  lStudID: string;
  lStudentHealthCondition: TAMGStudentHealthCondition;
  i: Integer;
  lIdx: Integer;
begin
  for i :=  0 to lsvStudentHealthCond.Items.Count - 1 do
  begin
    if Assigned(lsvStudentHealthCond.Items[i].Data) then
    begin
      lStudentHealthCondition := TAMGStudentHealthCondition(lsvStudentHealthCond.Items[i].Data);
      lIdx := StudentHealthConditions.GetIssueIndex(lStudentHealthCondition.StudentCode, lStudentHealthCondition.HealthConditionCode);
      lStudentHealthCondition.HasHealthSupportPlan := chkHealthSupportPlan.Checked;
      lStudentHealthCondition.KeySuportPerson := Trim(edtKeySupportPerson.Text);
      lStudentHealthCondition.EmergencyContact := Trim(edtEmergencyContact.Text);
      lStudentHealthCondition.EmergencyContactNo := Trim(edtEmergencyContactNo.Text);
      lStudentHealthCondition.OtherRelevantInfo := Trim(edtOtherRelevanInfo.Text);

      if lIdx = -1 then
      begin
        StudentHealthConditions.Add(lStudentHealthCondition);
      end;
    end;
  end;
  StudentHealthConditions.SaveToFile;
end;

procedure TFrmHealthCondition.SetupMenu(Sender: TObject);
begin
  if Assigned(lsvStudentHealthCond.Selected) and (Assigned(TAMGStudentHealthCondition(lsvStudentHealthCond.Selected.Data))) then
  begin
    popHCRemovefromPeersupportGrooup.Visible := TAMGStudentHealthCondition(lsvStudentHealthCond.Selected.Data).IsInPeerSupport;
    popHealthCondMoreDetails.Visible := True;
    PopHealtCondRemove.Visible := True;
  end
  else
  begin
    popHCRemovefromPeersupportGrooup.Visible := False;
    popHealthCondMoreDetails.Visible := False;
    PopHealtCondRemove.Visible := False;
  end;

  popHCAddtoPeerSupportGroup.Visible := Assigned(lsvStudentHealthCond.Selected) and (not popHCRemovefromPeersupportGrooup.Visible);
end;

procedure TFrmHealthCondition.SetUserAccess;
begin
  btnAddCondition.Enabled := FHasAccess;
  btnSaveStudentHealth.Enabled := FHasAccess;
  PopHealtCondRemove.Enabled := FHasAccess;
  popHCAddtoPeerSupportGroup.Enabled := FHasAccess;
  popHCRemovefromPeersupportGrooup.Enabled := FHasAccess;
  btnCreateHealthCondtion.Enabled := FHasAccess;
  memStudentHealthNote.Enabled := FHasAccess;
  chkHealthSupportPlan.Enabled := FHasAccess;
  edtKeySupportPerson.Enabled := FHasAccess;
  edtEmergencyContact.Enabled := FHasAccess;
  edtEmergencyContactNo.Enabled := FHasAccess;
  edtOtherRelevanInfo.Enabled := FHasAccess;
end;

end.
