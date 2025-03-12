page 50804 "Issue Inventory Factbox."
{
    ApplicationArea = All;
    Caption = 'Issue Inventory Factbox.';
    PageType = CardPart;
    SourceTable = Item;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }

                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies what you are selling.';
                }
                field("Available quantity"; ItemInventory)
                {
                    ToolTip = 'Specifies what you are selling.';
                }

                field("Location Code"; LocationCode)
                {
                    ToolTip = 'Specifies what you are selling.';
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        ItemVar: Record Item;
    begin
        ItemVar.SetRange("No.", Rec."No.");
        ItemVar.SetRange("Location Filter", LocationCode);
        if ItemVar.FindSet() then begin
            ItemVar.CalcFields(Inventory);
            ItemInventory := ItemVar.Inventory;
        end;



    end;

    procedure SetLocation(Value: Code[10])
    begin
        LocationCode := Value;
    end;

    var
        ItemInventory: Decimal;
        LocationCode: Code[10];
}
