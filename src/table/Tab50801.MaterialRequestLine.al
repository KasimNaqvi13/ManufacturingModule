table 50801 "Material Request Line"
{
    Caption = 'Material Request Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'Material Request No.';
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(3; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(5; Quantity; Decimal)
        {
            Caption = 'Requested Quantity';
        }
        field(6; "Unit of measure"; Code[10])
        {
            Caption = 'Unit of easure';
        }
        field(8; "Outstanding Quantity"; Decimal)
        {
            Caption = 'Outstanding Quantity';
        }
        field(9; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(10; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
        }
        field(11; "Shortcut Dimension 1 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        field(12; "Shortcut Dimension 2 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        field(13; Location; Code[20])
        {
            Caption = 'Location';
        }
        field(14; "Quantity(Base)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Original Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Original Variant Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Varient Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "No.", "Line No.", "Item No.")
        {
            Clustered = true;
        }
    }

    procedure ShowLineDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
            DimMgt.EditDimensionSet(
                Rec, "Dimension Set ID", StrSubstNo('%1 %2', TableCaption(), "Line No."),
                "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        if OldDimSetID <> "Dimension Set ID" then begin
            Modify();
        end;
    end;

    procedure OpenItemTrackingLines()
    begin
        //ProdOrderLineReserve.CallItemTracking(Rec);
    end;

    var
        DimMgt: Codeunit DimensionManagement;
        ProdOrderLineReserve: Codeunit "Prod. Order Line-Reserve";
}
