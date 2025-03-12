page 50801 "Material Request List"
{
    ApplicationArea = All;
    Caption = 'Material Requests';
    PageType = List;
    SourceTable = "Material Request Header";
    UsageCategory = Lists;
    CardPageId = 50800;
    //DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Material Request No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the Material request no. field.', Comment = '%';
                }
                field("Request Description"; Rec."Request description")
                {
                    ToolTip = 'Specifies the value of the Request description field.', Comment = '%';
                }
                field("Source Type"; Rec."Source type")
                {
                    ToolTip = 'Specifies the value of the Source type field.', Comment = '%';
                }
                field("Approval Status"; Rec."Approval status")
                {
                    ToolTip = 'Specifies the value of the Approval status field.', Comment = '%';
                }
                field("Creating Date"; Rec."Creating date")
                {
                    ToolTip = 'Specifies the value of the Creating date field.', Comment = '%';
                }
                field("From Location"; Rec."From location")
                {
                    ToolTip = 'Specifies the value of the From location field.', Comment = '%';
                }
                field("To Location"; Rec."To location")
                {
                    ToolTip = 'Specifies the value of the To location field.', Comment = '%';
                }
                field("Requestor Name"; Rec."Requestor Name")
                {

                }
            }
        }
    }
}
