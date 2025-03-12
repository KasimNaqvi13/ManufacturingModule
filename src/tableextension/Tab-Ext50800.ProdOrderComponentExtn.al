tableextension 50800 "Prod. Order Component Extn" extends "Prod. Order Component"
{
    fields
    {
        field(50800; IsRequested; Boolean)
        {
            Caption = 'IsRequested';
            DataClassification = ToBeClassified;
        }

        field(50801; ModifiedQuantity; Decimal)
        {
            Caption = 'ModifiedQuant';
            DataClassification = ToBeClassified;
        }

    }

    trigger OnModify()
    var
        ProdComponent: Record "Prod. Order Component";
    begin
        if (xRec."Item No." = Rec."Item No.") and (xRec."Quantity per" <> Rec."Quantity per") then begin
            if Rec."Expected Quantity" - XRec."Expected Quantity" > 0 then begin
                ModifiedQuantity := Rec."Expected Quantity" - XRec."Expected Quantity";
            end
            else begin
                ModifiedQuantity := Rec."Expected Quantity";
            end;
            IsRequested := false;
        end
        else begin
            IsRequested := false;
            ModifiedQuantity := 0;
        end;
    end;
}