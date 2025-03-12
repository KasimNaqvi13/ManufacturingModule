page 50800 "Material Request"
{
    ApplicationArea = All;
    Caption = 'Material Request';
    PageType = Document;
    SourceTable = "Material Request Header";
    DataCaptionFields = "No.";
    //DeleteAllowed = false;


    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = Location;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    Visible = true;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Source Type"; Rec."Source type")
                {
                    ToolTip = 'Specifies the value of the Source type field.';
                    Caption = 'Source Type';
                }
                field("Source No."; Rec."Source No.")
                {

                }
                field("Request Description"; Rec."Request description")
                {
                    ToolTip = 'Specifies the value of the Request description field.';
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    Editable = false;
                }
                field("Creating Date"; Rec."Creating date")
                {
                    ToolTip = 'Specifies the value of the Creating date field.';
                }
                field("From Location"; Rec."From location")
                {
                    ToolTip = 'Specifies the value of the From location field.';
                    NotBlank = true;
                    ShowMandatory = true;
                }
                field("To Location"; Rec."To location")
                {
                    ToolTip = 'Specifies the value of the To location field.';
                    NotBlank = true;
                    ShowMandatory = true;
                }
                field("Requestor Name"; Rec."Requestor Name")
                {
                    NotBlank = true;

                }
                field("Approval Status"; Rec."Approval status")
                {
                    ToolTip = 'Specifies the value of the Approval status field.';
                    Editable = false;
                }
                field(VariantCode; Rec.VarientCode)
                {
                    ApplicationArea = All;
                }

            }
            part(MaterialRequestLine; "Material request Subform")
            {
                SubPageLink = "No." = field("No.");
            }
            group("Transfer-from")
            {
                Caption = 'Transfer-from';
                field("Transfer-from Name"; Rec."Transfer-from Name")
                {
                    ApplicationArea = Location;
                    Caption = 'Name';
                    Editable = false;
                    ToolTip = 'Specifies the name of the sender at the location that the items are transferred from.';
                }
                field("Transfer-from Name 2"; Rec."Transfer-from Name 2")
                {
                    ApplicationArea = Location;
                    Caption = 'Name 2';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies an additional part of the name of the sender at the location that the items are transferred from.';
                }
                field("Transfer-from Address"; Rec."Transfer-from Address")
                {
                    ApplicationArea = Location;
                    Caption = 'Address';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the address of the location that the items are transferred from.';
                }
                field("Transfer-from Address 2"; Rec."Transfer-from Address 2")
                {
                    ApplicationArea = Location;
                    Caption = 'Address 2';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies an additional part of the address of the location that items are transferred from..';
                }
                field("Transfer-from City"; Rec."Transfer-from City")
                {
                    ApplicationArea = Location;
                    Caption = 'City';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the city of the location that the items are transferred from.';
                }
                group(Control21)
                {
                    ShowCaption = false;
                    field("Transfer-from County"; Rec."Transfer-from County")
                    {
                        ApplicationArea = Location;
                        Caption = 'County';
                        Editable = false;
                        Importance = Additional;
                    }
                }
                field("Transfer-from Post Code"; Rec."Transfer-from Post Code")
                {
                    ApplicationArea = Location;
                    Caption = 'Post Code';
                    Editable = false;
                    Importance = Additional;
                }
                field("Transfer-from Contact"; Rec."Transfer-from Contact")
                {
                    ApplicationArea = Location;
                    Caption = 'Contact';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the name of the contact person at the location that the items are transferred from.';
                }
            }
            group("Transfer-to")
            {
                Caption = 'Transfer-to';
                field("Transfer-to Name"; Rec."Transfer-to Name")
                {
                    ApplicationArea = Location;
                    Caption = 'Name';
                    Editable = false;
                    ToolTip = 'Specifies the name of the recipient at the location that the items are transferred to.';
                }
                field("Transfer-to Name 2"; Rec."Transfer-to Name 2")
                {
                    ApplicationArea = Location;
                    Caption = 'Name 2';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies an additional part of the name of the recipient at the location that the items are transferred to.';
                }
                field("Transfer-to Address"; Rec."Transfer-to Address")
                {
                    ApplicationArea = Location;
                    Caption = 'Address';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the address of the location that the items are transferred to.';
                }
                field("Transfer-to Address 2"; Rec."Transfer-to Address 2")
                {
                    ApplicationArea = Location;
                    Caption = 'Address 2';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies an additional part of the address of the location that items are transferred to.';
                }
                field("Transfer-to City"; Rec."Transfer-to City")
                {
                    ApplicationArea = Location;
                    Caption = 'City';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the city of the location that items are transferred to.';
                }
                group(Control19)
                {
                    ShowCaption = false;
                    field("Transfer-to County"; Rec."Transfer-to County")
                    {
                        ApplicationArea = Location;
                        Caption = 'County';
                        Editable = false;
                        Importance = Additional;
                    }
                }
                field("Transfer-to Post Code"; Rec."Transfer-to Post Code")
                {
                    ApplicationArea = Location;
                    Caption = 'Post Code';
                    Editable = false;
                    Importance = Additional;
                }
                field("Transfer-to Contact"; Rec."Transfer-to Contact")
                {
                    ApplicationArea = Location;
                    Caption = 'Contact';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the name of the contact person at the location that items are transferred to.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(Home)
            {
                Caption = 'Home';
                Image = Home;

                action("Request to Issue")
                {
                    Image = TransferOrder;
                    ApplicationArea = All;
                    Caption = 'Request to Issue';
                    Enabled = not Rec.IsIssue;
                    trigger OnAction()
                    var
                        RequestandIssueManagement: Codeunit RequestandIssueManagement;
                        MaterialRequestHeader: record "Material Request Header";
                        RecRestrMnmgt: Codeunit "Record Restriction Mgt.";
                    begin
                        validations();
                        RequestandIssueManagement.MaterialLineCheck(Rec."No.");
                        // if (Rec."Approval status" = Rec."Approval status"::Open) then
                        //     Error('Approval is needed to raise the request')
                        // else
                        //     RecRestrMnmgt.CheckRecordHasUsageRestrictions(Rec);
                        // RequestandIssueManagement.TransferToTransferOrder(Rec."No.");
                        RequestandIssueManagement.CreateTransferOrder(Rec);
                        Rec.IsIssue := true;
                    end;
                }
                action(cleardata)
                {

                    trigger OnAction()
                    var
                        ProdorderComp: Record "Prod. Order Component";
                    begin
                        ProdorderComp.SetRange("Prod. Order No.", Rec."Source No.");
                        if ProdorderComp.FindSet() then
                            ProdorderComp.ModifyAll(IsRequested, false);
                    end;
                }
                group(RequestApproval)
                {
                    Caption = 'Request Approval';
                    Image = Approvals;
                    action(SendApprovalRequest)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Send A&pproval Request';
                        Image = SendApprovalRequest;
                        ToolTip = 'Request approval of the document.';

                        trigger OnAction()
                        var
                            ApprovalsMgmtCus: Codeunit CustomApprovalWorkflow;
                        begin
                            validations();
                            if ApprovalsMgmtCus.CheckMaterialReqApprovalPossible(Rec) then begin
                                ApprovalsMgmtCus.OnSendMatReqDocForApproval(Rec);
                            end;
                        end;
                    }

                    action(CancelApprovalRequest)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Cancel Approval Re&quest';
                        Image = CancelApprovalRequest;
                        ToolTip = 'Cancel the approval request.';

                        trigger OnAction()
                        var
                            ApprovalsMgmtCus: Codeunit CustomApprovalWorkflow;
                        begin
                            ApprovalsMgmtCus.OnCancelMatReqApprovalRequest(Rec);
                            WorkflowWebhookMgt.FindAndCancel(Rec.RecordId);
                        end;
                    }
                }

                group(Order)
                {
                    Caption = 'Order';
                    Image = Order;
                    action(Dimensions)
                    {
                        AccessByPermission = TableData Dimension = R;
                        ApplicationArea = Dimensions;
                        Caption = 'Dimensions';
                        Image = Dimensions;
                        ShortCutKey = 'Alt+D';
                        ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                        trigger OnAction()
                        begin
                            //DimMgt.ShowDimensionSet(Rec."Dimension Set ID", Rec."Request description");
                            Rec."Dimension Set ID" := DimMgt.EditDimensionSet(Rec."Dimension Set ID", Rec."Request description");
                            Rec.Modify(true);
                        end;
                    }

                    action(Attachments)
                    {
                        ApplicationArea = All;
                        Caption = 'Attachments';
                        Image = Attach;
                        ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                        trigger OnAction()
                        var
                            DocumentAttachmentDetails: Page "Document Attachment Details";
                            RecRef: RecordRef;
                            ItemPage: Page "Item List";
                        begin
                            RecRef.GetTable(Rec);
                            DocumentAttachmentDetails.OpenForRecRef(RecRef);
                            DocumentAttachmentDetails.RunModal();
                        end;
                    }
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                group(Category_Category6)
                {
                    Caption = 'Posting';
                    ShowAs = SplitButton;
                    actionref(Post_Promoted; "Request to Issue")
                    {
                    }
                }
            }
            group(Category_Approval)
            {
                Caption = 'Request Approval';
                actionref(Post_Promoted2; SendApprovalRequest)
                {
                }
                actionref(Post_Promoted3; CancelApprovalRequest)
                {

                }
            }
            group(Category_New)
            {
                Caption = 'Order';
                actionref(Post_Promoted4; Dimensions)
                {

                }
                actionref(Post_Promoted5; Attachments)
                {

                }
            }
        }
    }
    trigger OnDeleteRecord(): Boolean
    var

        prodordComp: Record "Prod. Order Component";
    begin
        if Rec.IsIssue then begin
            Error('You cannot delete the request, Request is rised already');
        end
        else begin
            prodordComp.SetRange("Prod. Order No.", Rec."Source No.");
            if prodordComp.FindSet() then begin
                prodordComp.ModifyAll(IsRequested, false);
            end;

        end;
    end;

    procedure validations()

    begin
        if (Rec."Source No." = '') then
            Error('Source No. is mandatory');
        if (Rec."From location" = '') or (Rec."To location" = '') then begin
            Error('Location field is mandatory');
        end;
    end;




    var
        DimMgt: Codeunit DimensionManagement;
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";

}