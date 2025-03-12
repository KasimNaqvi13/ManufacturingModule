page 50810 "IssueHeader(Trans)"
{
    ApplicationArea = All;
    Caption = 'Material Issue';
    PageType = Document;
    SourceTable = "Transfer Header";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                    ToolTip = 'Specifies the code of the location that items are transferred from.';
                    NotBlank = true;
                    Editable = false;

                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ToolTip = 'Specifies the code of the location that the items are transferred to.';
                    NotBlank = true;
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the posting date of the transfer order.';
                    Editable = false;
                }
                field(RequestNo; Rec.RequestNo)
                {
                    ToolTip = 'Specifies the value of the Request No. field.', Comment = '%';
                    Editable = false;
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
                field("Source No."; Rec."Source No.")
                {
                    Editable = false;
                }
                field(SourceType; Rec.SourceType)
                {
                    Caption = 'Source Type';
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Issue Description';
                }
                field(Quantity; Rec.Quantity)
                {
                    Caption = 'Production Quantity';
                    Editable = false;
                }
                field(Status; Rec.Status)
                {

                }
            }
            part(IssueLine; "IssueLine(Trans)")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");

            }
        }

        area(FactBoxes)
        {
            part(Item; Item)
            {

                ApplicationArea = All;
                Provider = IssueLine;
                SubPageLink = "No." = field("Item No.");
            }
            part(Variants; variants)
            {
                ApplicationArea = All;
                Provider = IssueLine;
                SubPageLink = "Item No." = field("Item No.");
            }




        }
    }
    actions
    {
        area(navigation)
        {
            group("O&rder")
            {
                Caption = 'O&rder';
                Image = "Order";
                action(Statistics)
                {
                    ApplicationArea = Location;
                    Caption = 'Statistics';
                    Image = Statistics;
                    RunObject = Page "Transfer Statistics";
                    RunPageLink = "No." = field("No.");
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information about the transfer order, such as the quantity and total weight transferred.';
                }
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Inventory Comment Sheet";
                    RunPageLink = "Document Type" = const("Transfer Order"),
                                  "No." = field("No.");
                    ToolTip = 'View or add comments for the record.';
                }
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
                        Rec.ShowDocDim();
                        CurrPage.SaveRecord();
                    end;
                }
            }
        }
        area(processing)
        {
            group(Release)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action("Re&lease")
                {
                    ApplicationArea = Location;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';
                    ToolTip = 'Release the document to the next stage of processing. You must reopen the document before you can make changes to it.';

                    trigger OnAction()
                    begin
                        // Rec.PerformManualRelease();
                        Rec.Status := Rec.Status::Released; // No actual change
                        Rec.Modify(true);
                    end;
                }
                action("Reo&pen")
                {
                    ApplicationArea = Location;
                    Caption = 'Reo&pen';
                    Image = ReOpen;
                    ToolTip = 'Reopen the transfer order after being released for warehouse handling.';

                    trigger OnAction()
                    var
                        ReleaseTransferDoc: Codeunit "Release Transfer Document";
                    begin
                        ReleaseTransferDoc.Reopen(Rec);
                        Rec.Status := Rec.Status::Open;
                        Rec.Modify();
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Post)
                {
                    ApplicationArea = Location;
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = PostOrder;
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction()
                    var
                        TransferReceiptHeader: record "Transfer Receipt Header";
                    begin
                        CODEUNIT.Run(CODEUNIT::"TransferOrder-Post (Yes/No)", Rec);
                        TransferReceiptHeader.SetRange("Transfer Order No.", Rec."No.");
                        if TransferReceiptHeader.FindFirst() then begin
                            TransferReceiptHeader.IsPosted := true;
                            TransferReceiptHeader."Request No." := Rec.RequestNo;
                            TransferReceiptHeader.Modify(true);
                            Rec.Status := Rec.Status::Released;
                            Rec.Modify();
                        end;
                    end;

                }
                action(PreviewPosting)
                {
                    ApplicationArea = Location;
                    Caption = 'Preview Posting';
                    Image = ViewPostedOrder;
                    ShortCutKey = 'Ctrl+Alt+F9';
                    ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';

                    trigger OnAction()
                    begin
                        ShowPreview();
                        CurrPage.Update(false);
                    end;
                }
            }
        }

        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                group(Category_Category5)
                {
                    Caption = 'Posting', Comment = 'Generated from the PromotedActionCategories property index 4.';
                    ShowAs = SplitButton;

                    actionref(Post_Promoted; Post)
                    {
                    }
                    actionref(PreviewPosting_Promoted; PreviewPosting)
                    {
                    }
                }
                group(Category_Category4)
                {
                    Caption = 'Release', Comment = 'Generated from the PromotedActionCategories property index 3.';
                    ShowAs = SplitButton;

                    actionref("Re&lease_Promoted"; "Re&lease")
                    {
                    }
                    actionref("Reo&pen_Promoted"; "Reo&pen")
                    {
                    }
                }
            }
            group(Category_Category6)
            {
                Caption = 'Order', Comment = 'Generated from the PromotedActionCategories property index 5.';

                actionref(Dimensions_Promoted; Dimensions)
                {
                }
                actionref(Statistics_Promoted; Statistics)
                {
                }
                actionref("Co&mments_Promoted"; "Co&mments")
                {
                }
                separator(Navigate_Separator)
                {
                }
            }
            group(Category_Category7)
            {
                Caption = 'Documents', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category9)
            {
                Caption = 'Navigate', Comment = 'Generated from the PromotedActionCategories property index 8.';
            }
            group(Category_Report)
            {
                Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';

#if not CLEAN21

#endif
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        EnableTransferFields := not IsPartiallyShipped();
        ActivateFields();
        CurrPage.Variants.Page.SetLocation(Rec."Transfer-from Code");
        CurrPage.Item.Page.SetLocation(Rec."Transfer-from Code");
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Rec.TestField(Status, Rec.Status::Open);
    end;

    trigger OnOpenPage()
    begin
        SetDocNoVisible();
#if not CLEAN23
        EnableTransferFields := not IsPartiallyShipped();
        ActivateFields();
#endif
        SetEditableMode();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        SetEditableMode();
    end;

    trigger OnInit()
    begin
        SetEditableMode();
    end;

    var
        FormatAddress: Codeunit "Format Address";
        DocNoVisible: Boolean;
        IsFromCountyVisible: Boolean;
        IsToCountyVisible: Boolean;
        IsTransferLinesEditable: Boolean;

        Text000: Label 'Do you want to change %1 in all related records in the warehouse?';

    protected var
        EnableTransferFields: Boolean;

    procedure SetEditableMode()
    var
        IsEditable: Boolean;
    begin
        if (Rec.Status = Rec.Status::Released) then
            IsEditable := false
        else
            IsEditable := true;

        CurrPage.Editable := IsEditable;
    end;

    local procedure ActivateFields()
    begin
        IsFromCountyVisible := FormatAddress.UseCounty(Rec."Trsf.-from Country/Region Code");
        IsToCountyVisible := FormatAddress.UseCounty(Rec."Trsf.-to Country/Region Code");
        IsTransferLinesEditable := Rec.TransferLinesEditable();
    end;

    local procedure PostingDateOnAfterValidate()
    begin
        CurrPage.IssueLine.PAGE.UpdateForm(true);
    end;

    local procedure ShipmentDateOnAfterValidate()
    begin
        CurrPage.IssueLine.PAGE.UpdateForm(false);
    end;

    local procedure ShippingAgentServiceCodeOnAfte()
    begin
        CurrPage.IssueLine.PAGE.UpdateForm(false);
    end;

    local procedure ShippingAgentCodeOnAfterValida()
    begin
        CurrPage.IssueLine.PAGE.UpdateForm(false);
    end;

    local procedure ShippingTimeOnAfterValidate()
    begin
        CurrPage.IssueLine.PAGE.UpdateForm(false);
    end;

    local procedure ReceiptDateOnAfterValidate()
    begin
        CurrPage.IssueLine.PAGE.UpdateForm(false);
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
    begin
        DocNoVisible := DocumentNoVisibility.TransferOrderNoIsVisible();
    end;

    local procedure IsPartiallyShipped(): Boolean
    var
        TransferLine: Record "Transfer Line";
    begin
        TransferLine.SetRange("Document No.", Rec."No.");
        TransferLine.SetFilter("Quantity Shipped", '> 0');
        exit(not TransferLine.IsEmpty);
    end;

    local procedure ShowPreview()
    var
        TransferOrderPostYesNo: Codeunit "TransferOrder-Post (Yes/No)";
    begin
        TransferOrderPostYesNo.Preview(Rec);
    end;




}

