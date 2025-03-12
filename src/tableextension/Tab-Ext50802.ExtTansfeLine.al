tableextension 50802 "Ext. Tansfe Line" extends "Transfer Line"
{
    fields
    {
        field(50800; "Is Issue"; Boolean)
        {
            Caption = 'Is Issue';
            DataClassification = ToBeClassified;
        }
        field(50801; RequestNo; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Request No.';
        }
        field(50802; "Qty to issue"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Qty to issue';

            trigger OnValidate()
            var
            begin
                if "Qty to issue" > Quantity - "Quantity Shipped" then
                    Error('you cannot ship more than %1 Quantity', Quantity)
                else if "Qty to issue" < 0 then
                    Error('Quantity should be greater than 0');
                Validate("Qty. to Ship", Rec."Qty to issue");
                Validate("Qty. to Receive", Rec."Qty to issue");
            end;
        }
    }
}
