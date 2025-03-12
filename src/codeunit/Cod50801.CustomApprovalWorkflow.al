codeunit 50801 CustomApprovalWorkflow
{

    procedure RunWorkflowOnSendMaterialReqDocForApprovalCode(): Code[128]
    begin
        exit('RUNWORKFLOWONSENDMATERIALREQDOCFORAPPROVAL');
    end;

    procedure RunWorkflowOnCancelMaterialReqDocApprovalRequestCode(): Code[128]
    begin
        exit('RUNWORKFLOWONCANCELMATERIALREQDOCFORAPPROVAL');
    end;


    procedure CheckMaterialReqApprovalPossible(var MaterialReqHeader: Record "Material Request Header"): Boolean
    var
        IsHandled: Boolean;
        Result: Boolean;
    begin
        IsHandled := false;
        OnBeforeCheckMaterialReqApprovalPossible(MaterialReqHeader, Result, IsHandled);
        if IsHandled then
            exit(Result);
        if not IsMaterialReqApprovalsWorkflowEnabled(MaterialReqHeader) then
            Error(NoWorkflowEnabledErr);
        if not MaterialReqHeader.ProdOrderLineExist() then
            Error(NothingToApproveErr);
        OnAfterCheckMaterialReqApprovalPossible(MaterialReqHeader);
        exit(true);
    end;

    procedure IsMaterialReqApprovalsWorkflowEnabled(var MaterialReqHeader: Record "Material Request Header"): Boolean
    begin
        exit(WorkflowManagement.CanExecuteWorkflow(MaterialReqHeader, RunWorkflowOnSendMaterialReqDocForApprovalCode()));
    end;



    procedure BuildMaterialReqHeaderTypeConditionsText(ApprovalStatus: Enum "Material Request Status"): Text
    var
        MaterialReqHeader: Record "Material Request Header";
        MaterialReqLine: Record "Material Request Line";
    begin // Referred from Codeunit::"Workflow Setup"
        MaterialReqHeader.SetRange("Approval Status", ApprovalStatus);
        exit(StrSubstNo(MatReqHeaderTypeCondnTxt, WorkflowSetup.Encode(MaterialReqHeader.GetView(false)), WorkflowSetup.Encode(MaterialReqLine.GetView(false))));
    end;



    local procedure InsertMaterialReqDocumentWorkflowDetails(var Workflow: Record Workflow)
    var
        MaterialReqHeaderDocument: Record "Material Request Header";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin // Referred from Codeunit::"Workflow Setup"
        WorkflowSetup.InitWorkflowStepArgument(
            WorkflowStepArgument, WorkflowStepArgument."Approver Type"::Approver,
            WorkflowStepArgument."Approver Limit Type"::"Direct Approver", 0, '', BlankDateFormula, true);

        WorkflowSetup.InsertDocApprovalWorkflowSteps(
            Workflow,
            BuildMaterialReqHeaderTypeConditionsText(MaterialReqHeaderDocument."Approval Status"::Open),
            RunWorkflowOnSendMaterialReqDocForApprovalCode(),
            BuildMaterialReqHeaderTypeConditionsText(MaterialReqHeaderDocument."Approval Status"::"Pending Approval"),
            RunWorkflowOnCancelMaterialReqDocApprovalRequestCode(),
            WorkflowStepArgument, true);
    end;

    local procedure InsertMatReqDocumentWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin // Referred from Codeunit::"Workflow Setup"
        WorkflowSetup.InsertWorkflowTemplate(Workflow, MatReqOrderApprWorkflowCodeTxt, MatReqOrderApprWorkflowDescTxt, MatReqDocCategoryTxt);
        InsertMaterialReqDocumentWorkflowDetails(Workflow);
        WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertMaterialReqHeaderReqPageFields()
    var
        MaterialReqHeader: Record "Material Request Header";
    begin // Referred from Codeunit::"Workflow Request Page Handling"
        WorkflowReqPageHander.InsertDynReqPageField(DATABASE::"Material Request Header", MaterialReqHeader.FieldNo("From location"));
        WorkflowReqPageHander.InsertDynReqPageField(DATABASE::"Material Request Header", MaterialReqHeader.FieldNo("To location"));
    end;

    local procedure InsertMatReqLineReqPageFields()
    var
        MatReqLine: Record "Material Request Line";
    begin // Referred from Codeunit::"Workflow Request Page Handling"
        WorkflowReqPageHander.InsertDynReqPageField(DATABASE::"Material Request Line", MatReqLine.FieldNo("Item No."));
        WorkflowReqPageHander.InsertDynReqPageField(DATABASE::"Material Request Line", MatReqLine.FieldNo(Quantity));
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeCheckMaterialReqApprovalPossible(var MaterialReqHeader: Record "Material Request Header"; var Result: Boolean; var IsHandled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterCheckMaterialReqApprovalPossible(var MaterialReqHeader: Record "Material Request Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeIsSufficientMatReqApprover(var UserSetup: Record "User Setup"; var IsSufficient: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeReleaseMatReqDoc(var MaterialReqHeader: Record "Material Request Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterReleaseMatReqDoc(var MaterialReqHeader: Record "Material Request Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendMatReqDocForApproval(var MaterialReqHeader: Record "Material Request Header")
    begin // Triggered in Material Request Header
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelMatReqApprovalRequest(var MaterialReqHeader: Record "Material Request Header")
    begin // Triggered in Material Request Header
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure AddWorkflowEventsToLibrary()
    var
        WorkflowEventHandler: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandler.AddEventToLibrary(RunWorkflowOnSendMaterialReqDocForApprovalCode(), DATABASE::"Material Request Header",
            MatReqDocSendForApprovalEventDescTxt, 0, false);
        WorkflowEventHandler.AddEventToLibrary(RunWorkflowOnCancelMaterialReqDocApprovalRequestCode(), DATABASE::"Material Request Header",
            MatReqDocApprReqCancelledEventDescTxt, 0, false);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    local procedure AddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    var
        WorkflowEventHandler: Codeunit "Workflow Event Handling";
    begin
        case EventFunctionName of
            WorkflowEventHandler.RunWorkflowOnApproveApprovalRequestCode():
                begin
                    WorkflowEventHandler.AddEventPredecessor(
                        WorkflowEventHandler.RunWorkflowOnApproveApprovalRequestCode(),
                        RunWorkflowOnSendMaterialReqDocForApprovalCode());
                end;
            WorkflowEventHandler.RunWorkflowOnRejectApprovalRequestCode():
                begin
                    WorkflowEventHandler.AddEventPredecessor(
                        WorkflowEventHandler.RunWorkflowOnRejectApprovalRequestCode(),
                        RunWorkflowOnSendMaterialReqDocForApprovalCode());
                end;
            WorkflowEventHandler.RunWorkflowOnDelegateApprovalRequestCode():
                begin
                    WorkflowEventHandler.AddEventPredecessor(
                        WorkflowEventHandler.RunWorkflowOnDelegateApprovalRequestCode(),
                        RunWorkflowOnSendMaterialReqDocForApprovalCode());
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddWorkflowCategoriesToLibrary', '', false, false)]
    local procedure InsertWorkflowCategories()
    begin
        WorkflowSetup.InsertWorkflowCategory(MatReqDocCategoryTxt, MatReqDocCategoryDescTxt);
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnInsertWorkflowTemplates', '', false, false)]
    local procedure InsertWorkflowTemplates()
    begin
        InsertMatReqDocumentWorkflowTemplate();
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAfterInsertApprovalsTableRelations', '', false, false)]
    local procedure InsertApprovalsTableRelations()
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        WorkflowSetup.InsertTableRelation(
            DATABASE::"Material Request Header", 0,
            DATABASE::"Approval Entry",
            ApprovalEntry.FieldNo("Record ID to Approve"));
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Request Page Handling", 'OnAfterInsertRequestPageEntities', '', false, false)]
    local procedure InsertRequestPageEntities()
    begin
        WorkflowReqPageHander.InsertReqPageEntity(
            MatReqDocumentCodeTxt, MatReqDocumentDescTxt, DATABASE::"Material Request Header", DATABASE::"Material Request Line");
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Request Page Handling", 'OnAfterInsertRequestPageFields', '', false, false)]
    local procedure InsertRequestPageFields()
    begin
        InsertMaterialReqHeaderReqPageFields();
        InsertMatReqLineReqPageFields();
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Request Page Handling", 'OnAfterAssignEntitiesToWorkflowEvents', '', false, false)]
    local procedure AssignEntityToWorkflowEvent()
    begin
        WorkflowReqPageHander.AssignEntityToWorkflowEvent(DATABASE::"Material Request Header", MatReqDocCategoryTxt);
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::CustomApprovalWorkflow, 'OnSendmatReqDocForApproval', '', false, false)]
    local procedure RunWorkflowOnSendMatReqDocForApproval(var MaterialReqHeader: Record "Material Request Header")
    begin // Referred from Codeunit::"Workflow Event Handling"
        WorkflowManagement.HandleEvent(RunWorkflowOnSendMaterialReqDocForApprovalCode(), MaterialReqHeader);
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::CustomApprovalWorkflow, 'OnCancelMatReqApprovalRequest', '', false, false)]
    local procedure RunWorkflowOnCancelMatreqApprovalRequest(var MaterialReqHeader: Record "Material Request Header")
    begin // Referred from Codeunit::"Workflow Event Handling"
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelMaterialReqDocApprovalRequestCode(), MaterialReqHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure SetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        MaterialReqHeader: Record "Material Request Header";
    begin
        case RecRef.Number of
            DATABASE::"Material Request Header":
                begin
                    RecRef.SetTable(MaterialReqHeader);
                    MaterialReqHeader."Approval Status" := MaterialReqHeader."Approval Status"::"Pending Approval";
                    MaterialReqHeader.Modify(true);
                    Variant := MaterialReqHeader;
                    IsHandled := true;
                end;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        IsModified: Boolean;
        MaterialReqHeader: Record "Material Request Header";
    begin
        case RecRef.Number of
            DATABASE::"Material Request Header":
                begin

                    Handled := true;
                    RecRef.SetTable(MaterialReqHeader);

                    if MaterialReqHeader."Approval Status" <> MaterialReqHeader."Approval Status"::Open then begin
                        MaterialReqHeader."Approval Status" := MaterialReqHeader."Approval Status"::Open;
                        IsModified := true;
                    end;

                    if IsModified then
                        MaterialReqHeader.Modify(true);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure ReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        IsModified: Boolean;
        MaterialReqHeader: Record "Material Request Header";
    begin
        case RecRef.Number of
            DATABASE::"Material Request Header":
                begin
                    // ReleasePurchaseDocument.PerformManualCheckAndRelease(Variant);
                    Handled := true;
                    RecRef.SetTable(MaterialReqHeader);
                    OnBeforeReleaseMatReqDoc(MaterialReqHeader);

                    if MaterialReqHeader."Approval Status" <> MaterialReqHeader."Approval Status"::Released then begin
                        MaterialReqHeader."Approval Status" := MaterialReqHeader."Approval Status"::Released;
                        IsModified := true;
                    end;

                    if IsModified then
                        MaterialReqHeader.Modify(true);
                    OnAfterReleaseMatReqDoc(MaterialReqHeader);
                end;
        end;
    end;

    var
        BlankDateFormula: DateFormula;
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowSetup: Codeunit "Workflow Setup";
        WorkflowReqPageHander: Codeunit "Workflow Request Page Handling";
        MatReqDocCategoryTxt: Label 'MATREQ', Locked = true;
        MatReqDocCategoryDescTxt: Label 'Material Request';
        MatReqDocumentCodeTxt: Label 'MATREQ', Locked = true;
        MatReqDocumentDescTxt: Label 'Material Request';
        MatReqOrderApprWorkflowCodeTxt: Label 'MATREQ-CUS-01', Locked = true;
        MatReqOrderApprWorkflowDescTxt: Label 'Materials Request Workflow';
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        NothingToApproveErr: Label 'There is nothing to approve.';
        MatReqHeaderTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Material Request Header">%1</DataItem><DataItem name="Material Request Line">%2</DataItem></DataItems></ReportParameters>', Locked = true;
        MatReqDocSendForApprovalEventDescTxt: Label 'Approval of a Material request document is requested.';
        MatReqDocApprReqCancelledEventDescTxt: Label 'An approval request for a Material request document is canceled.';
}




