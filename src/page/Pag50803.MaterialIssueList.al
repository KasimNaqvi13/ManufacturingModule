page 50803 "Material Issue List"
{
    ApplicationArea = All;
    Caption = 'Material Issues';
    PageType = List;
    SourceTable = "Transfer Header";
    UsageCategory = Lists;
    SourceTableView = where("Is Issue" = const(true));
    CardPageId = 50810;
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(RequestNo; Rec.RequestNo)
                {
                    ToolTip = 'Specifies the value of the Request No. field.', Comment = '%';
                    Caption = 'Request No.';
                }
                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                    ToolTip = 'Specifies the code of the location that items are transferred from.';
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ToolTip = 'Specifies the code of the location that the items are transferred to.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Request Description field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Requested Quantity field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {

                }
            }
        }
    }
}
