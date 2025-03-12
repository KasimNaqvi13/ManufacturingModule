table 50800 "Material Request Header"
{
    Caption = 'Material Request Header';
    DataClassification = ToBeClassified;
    DataCaptionFields = "No.", "Request description";
    LookupPageId = 50800;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    GetInventorySetup();
                    NoSeriesMgt.TestManual(GetNoSeriesCode());
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Source Type"; Option)
        {
            Caption = 'Source type';
            OptionMembers = "Released production order","Assembly Order";
        }
        field(3; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF ("Source Type" = CONST("Released Production Order"))
                    "Production Order"."No." WHERE(Status = FILTER(Released))
            ELSE
            IF ("Source Type" = CONST("Assembly Order"))
                    "Assembly Header"."No.";

            trigger OnValidate()
            var
                ReleasedProductionOrder: record "Production Order";
                MaterialReqLine: Record "Material Request Line";
            begin
                if xRec."Source No." <> Rec."Source No." then begin
                    if ReleasedProductionOrder.Get(ReleasedProductionOrder.Status::Released, "Source No.") then begin
                        "Request description" := ReleasedProductionOrder.Description;
                        "From Location" := ReleasedProductionOrder."Location Code";
                        Quantity := ReleasedProductionOrder.Quantity;
                        VarientCode := ReleasedProductionOrder."Variant Code";
                        "Dimension Set ID" := ReleasedProductionOrder."Dimension Set ID";
                    end;
                    MaterialReqLine.SetRange("No.", "No.");
                    if MaterialReqLine.FindSet() then begin
                        MaterialReqLine.DeleteAll();
                    end;

                end;
            end;
        }
        field(10; "Request Description"; Text[100])
        {
            Caption = 'Request Description';
        }
        field(13; "Quantity"; Decimal)
        {
        }
        field(5; "Creating Date"; Date)
        {
            Caption = 'Creating Date';
        }
        field(6; "Approval Status"; Enum "Material Request Status")
        {
            Caption = 'Approval Status';
            Editable = false;
        }
        field(8; "From Location"; Code[20])
        {
            Caption = 'From Location';
            TableRelation = Location;
        }
        field(9; "To Location"; Code[20])
        {
            Caption = 'To Location';
            TableRelation = Location;

            trigger OnValidate()
            var
            begin
                if Rec."From location" = Rec."To location" then
                    Error('You cannot select the same location for both the "From" and "To" locations. Please select different locations!');

            end;
        }
        field(11; "Requestor Name"; Code[50])
        {
            Caption = 'Assigned User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "User Setup";
        }
        field(12; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
        }
        field(14; "Shortcut Dimension 1 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        field(15; "Shortcut Dimension 2 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        field(16; VarientCode; Code[20])
        {
            Caption = 'Varient Code';
        }
        field(17; IsIssue; Boolean)
        {
            Caption = 'Is Issued';
        }

        field(19; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(20; "Transfer-from Code"; Code[10])
        {
            Caption = 'Transfer-from Code';
        }
        field(21; "Transfer-from Name"; Text[100])
        {
            Caption = 'Transfer-from Name';
        }
        field(22; "Transfer-from Name 2"; Text[50])
        {
            Caption = 'Transfer-from Name 2';
        }
        field(23; "Transfer-from Address"; Text[100])
        {
            Caption = 'Transfer-from Address';
        }
        field(24; "Transfer-from Address 2"; Text[50])
        {
            Caption = 'Transfer-from Address 2';
        }
        field(25; "Transfer-from Post Code"; Code[20])
        {
            Caption = 'Transfer-from Post Code';
        }
        field(26; "Transfer-from City"; Text[30])
        {
            Caption = 'Transfer-from City';
        }
        field(27; "Transfer-to Code"; Code[10])
        {
            Caption = 'Transfer-to Code';
        }
        field(28; "Transfer-to Name"; Text[100])
        {
            Caption = 'Transfer-to Name';
        }
        field(29; "Transfer-to Name 2"; Text[50])
        {
            Caption = 'Transfer-to Name 2';
        }
        field(30; "Transfer-to Address"; Text[100])
        {
            Caption = 'Transfer-to Address';
        }
        field(31; "Transfer-to Address 2"; Text[50])
        {
            Caption = 'Transfer-to Address 2';
        }
        field(32; "Transfer-to Post Code"; Code[20])
        {
            Caption = 'Transfer-to Post Code';
        }
        field(33; "Transfer-to City"; Text[30])
        {
            Caption = 'Transfer-to City';
        }
        field(34; "Transfer-to County"; Text[30])
        {
            Caption = 'Transfer-to County';
        }
        field(35; "Transfer-from Contact"; Text[100])
        {
            Caption = 'Transfer-from Contact';
        }
        field(36; "Transfer-to Contact"; Text[100])
        {
            Caption = 'Transfer-to Contact';
        }
        field(37; "Transfer-from County"; Text[50])
        {

        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        TestField("Source No.");
        "Dimension Set ID" :=
            DimMgt.EditDimensionSet(
                Rec, "Dimension Set ID", StrSubstNo('%1 %2', TableCaption(), "Source No."),
                "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        if OldDimSetID <> "Dimension Set ID" then begin
            Modify();
            if ProdOrderLineExist() then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure ProdOrderLineExist(): Boolean
    begin
        MaterialRequestLine.Reset();
        MaterialRequestLine.SetRange("No.", "No.");
        exit(MaterialRequestLine.FindFirst());
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        NewDimSetID: Integer;
        OldDimSetID: Integer;
    begin
        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not Confirm('Do you want to update dimensions for all lines?') then
            exit;

        MaterialRequestLine.Reset();
        MaterialRequestLine.SetRange("No.", "No.");
        MaterialRequestLine.LockTable();
        if MaterialRequestLine.Find('-') then
            repeat
                OldDimSetID := MaterialRequestLine."Dimension Set ID";
                NewDimSetID := DimMgt.GetDeltaDimSetID(MaterialRequestLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if MaterialRequestLine."Dimension Set ID" <> NewDimSetID then begin
                    MaterialRequestLine."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                        MaterialRequestLine."Dimension Set ID", MaterialRequestLine."Shortcut Dimension 1 Code", MaterialRequestLine."Shortcut Dimension 2 Code");
                    MaterialRequestLine.Modify();
                end;
            until MaterialRequestLine.Next() = 0;
    end;

    local procedure GetNoSeriesCode(): Code[20]
    var
        NoSeriesCode: Code[20];
        IsHandled: Boolean;
    begin
        GetInventorySetup();
        IsHandled := false;
        OnBeforeGetNoSeriesCode(Rec, InvtSetup, NoSeriesCode, IsHandled);
        if IsHandled then
            exit;

        NoSeriesCode := InvtSetup."Material Request Nos.";
        OnAfterGetNoSeriesCode(Rec, NoSeriesCode);
        exit(NoSeriesCode);
    end;

    local procedure GetInventorySetup()
    begin
        if not HasInventorySetup then begin
            InvtSetup.Get();
            HasInventorySetup := true;
        end;
    end;

    procedure AssistEdit(MaterialRequestHeaderOld: Record "Material Request Header"): Boolean
    begin
        with MaterialRequestHeader do begin
            MaterialRequestHeader := Rec;
            GetInventorySetup();
            TestNoSeries();
            if NoSeriesMgt.SelectSeries(GetNoSeriesCode(), MaterialRequestHeaderOld."No. Series", "No. Series") then begin
                NoSeriesMgt.SetSeries("No.");
                Rec := MaterialRequestHeader;
                exit(true);
            end;
        end;
    end;

    local procedure TestNoSeries()
    var
        IsHandled: Boolean;
    begin
        GetInventorySetup();
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, InvtSetup, IsHandled);
        if IsHandled then
            exit;

        InvtSetup.TestField("Transfer Order Nos.");
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(MaterialRequestHeader: Record "Material Request Header"; InvtSetup: Record "Inventory Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetNoSeriesCode(var MaterialRequestHeader: Record "Material Request Header"; InventorySetup: Record "Inventory Setup"; var NoSeriesCode: Code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetNoSeriesCode(var MaterialRequestHeader: Record "Material Request Header"; var NoSeriesCode: Code[20])
    begin
    end;


    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        //MaterialRequestLine: Record "Material Request Line";
        DimMgt: Codeunit DimensionManagement;
        InvtSetup: Record "Inventory Setup";
        InventorySetup: Record "Inventory Setup";
        MaterialRequestHeader: Record "Material Request Header";
        MaterialRequestLine: Record "Material Request Line";
        HasInventorySetup: Boolean;
}

