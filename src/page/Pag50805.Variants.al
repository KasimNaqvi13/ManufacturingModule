page 50805 "variants"
{
    ApplicationArea = All;
    Caption = 'Variants';
    PageType = ListPart;
    SourceTable = "Item Variant";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Caption = 'General';
                field("variant Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Available Quantity"; InvQty)
                {
                    ToolTip = 'Specifies the total quantity of the item that is currently in inventory at all locations.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies what you are selling.';
                }
                field("Location Code"; LocationCode)
                {
                    ToolTip = 'Specifies the total quantity of the item that is currently in inventory at all locations.';
                }

            }
        }
    }


    trigger OnAfterGetRecord()
    var
        ItemRec: Record Item;
    begin
        ItemRec.SetRange("No.", Rec."Item No.");
        ItemRec.SetRange("Location Filter", LocationCode);
        ItemRec.SetRange("Variant Filter", Rec.Code);

        if ItemRec.FindSet() then begin
            ItemRec.CalcFields(Inventory);
            InvQty := ItemRec.Inventory;
        end;
    end;

    procedure SetLocation(Value: Code[10])
    begin
        LocationCode := Value;
    end;

    var
        InvQty: Decimal;
        LocationCode: Code[10];
}