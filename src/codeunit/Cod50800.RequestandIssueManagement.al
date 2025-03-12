codeunit 50800 "RequestandIssueManagement"
{
    SingleInstance = false;
    Subtype = Normal;

    procedure TransferComponentsToRequest(ProductionOrderNo: Code[20]; var MaterialRequestHeader: Record "Material Request Header")
    var
        ProdOrderComp: Record "Prod. Order Component";
        MaterialRequestLine: Record "Material Request Line";
        LineNo: Integer;
    begin
        LineNo := 0;
        ProdOrderComp.SetRange("Prod. Order No.", ProductionOrderNo);
        ProdOrderComp.SetRange(Status, ProdOrderComp.Status::Released);
        ProdOrderComp.SetRange(IsRequested, false);
        if ProdOrderComp.FindSet() then begin
            repeat
                MaterialRequestLine.Init();
                MaterialRequestLine."No." := MaterialRequestHeader."No.";
                LineNo := LineNo + 1000;
                MaterialRequestLine."Line No." := LineNo;
                MaterialRequestLine."Item No." := ProdOrderComp."Item No.";
                MaterialRequestLine.Description := ProdOrderComp.Description;
                if ProdOrderComp.ModifiedQuantity > 0 then
                    MaterialRequestLine.Quantity := ProdOrderComp.ModifiedQuantity
                else
                    MaterialRequestLine.Quantity := ProdOrderComp."Expected Quantity";
                MaterialRequestLine."Unit of measure" := ProdOrderComp."Unit of Measure Code";
                MaterialRequestLine."Quantity(Base)" := ProdOrderComp."Quantity (Base)";
                MaterialRequestLine."Due Date" := ProdOrderComp."Due Date";
                MaterialRequestLine."Original Variant Code" := ProdOrderComp."Original Variant Code";
                MaterialRequestLine."Varient Code" := ProdOrderComp."Variant Code";
                MaterialRequestLine."Dimension Set ID" := ProdOrderComp."Dimension Set ID";
                MaterialRequestLine."Shortcut Dimension 1 Code" := ProdOrderComp."Shortcut Dimension 1 Code";
                MaterialRequestLine."Shortcut Dimension 2 Code" := ProdOrderComp."Shortcut Dimension 2 Code";
                MaterialRequestLine.Insert();
                ProdOrderComp.IsRequested := true;
                ProdOrderComp.Modify()
            until ProdOrderComp.Next() = 0;
        end
        else begin
            ProdOrderComp.Reset();
            ProdOrderComp.SetRange("Prod. Order No.", ProductionOrderNo);
            ProdOrderComp.SetRange(Status, ProdOrderComp.Status::Released);
            if ProdOrderComp.FindSet() then
                Error('Request already raised for this Production order %1', ProductionOrderNo)
            else
                Error('No components are available for this order');

        end;
    end;

    procedure TransferToTransferOrder(CurrMaterialRequestNo: Code[20])
    var
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        MaterialRequestHeader: Record "Material Request Header";
        MaterialRequestLine: Record "Material Request Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        LineNo: Integer;
    begin
        MaterialRequestHeader.SetRange("No.", CurrMaterialRequestNo);
        if MaterialRequestHeader.FindFirst() then begin
            // MaterialRequestHeader.IsISsue := true;
            TransferHeader.Init();
            TransferHeader.Insert(true);
            TransferHeader.RequestNo := CurrMaterialRequestNo;
            TransferHeader.Description := MaterialRequestHeader."Request Description";
            TransferHeader.Validate("Transfer-from Code", MaterialRequestHeader."To location");
            TransferHeader.Validate("Transfer-to Code", MaterialRequestHeader."From location");
            TransferHeader."Direct Transfer" := true;
            TransferHeader."Dimension Set ID" := MaterialRequestHeader."Dimension Set ID";
            TransferHeader.Description := MaterialRequestHeader."Request Description";
            TransferHeader."External Document No." := MaterialRequestHeader."No.";
            TransferHeader."Source No." := MaterialRequestHeader."Source No.";
            TransferHeader.SourceType := MaterialRequestHeader."Source type";
            TransferHeader."Shortcut Dimension 1 Code" := MaterialRequestHeader."Shortcut Dimension 1 Code";
            TransferHeader."Shortcut Dimension 2 Code" := MaterialRequestHeader."Shortcut Dimension 2 Code";
            TransferHeader.Quantity := MaterialRequestHeader.Quantity;
            TransferHeader.Modify(true);
            MaterialRequestLine.SetRange("No.", CurrMaterialRequestNo);
            if MaterialRequestLine.FindSet() then begin
                repeat
                    LineNo += 10000;
                    TransferLine.Init();
                    TransferLine.Validate("Document No.", TransferHeader."No.");
                    TransferLine."Line No." := LineNo;
                    TransferLine.Validate("Item No.", MaterialRequestLine."Item No.");
                    TransferLine.Insert(true);
                    TransferLine.RequestNo := CurrMaterialRequestNo;
                    TransferLine.Validate("Quantity (Base)", MaterialRequestLine."Quantity(Base)");
                    TransferLine.Validate(Quantity, MaterialRequestLine.Quantity);
                    TransferLine.Validate("Unit of Measure Code", MaterialRequestLine."Unit of measure");
                    TransferLine."Dimension Set ID" := MaterialRequestLine."Dimension Set ID";
                    TransferLine."Shortcut Dimension 1 Code" := MaterialRequestLine."Shortcut Dimension 1 Code";
                    TransferLine."Shortcut Dimension 2 Code" := MaterialRequestLine."Shortcut Dimension 2 Code";
                    TransferLine.Modify(true);
                until MaterialRequestLine.Next() = 0;
                Message('Material Issue is created against this request');
            end;

        end;

        TransferHeader."Is Issue" := true;
        TransferHeader.Modify(true);
        TransferLine.ModifyAll("Is Issue", true);
    end;

    procedure MaterialLineCheck(var MatReqNo: Code[20])
    var
        MaterialReqLine: Record "Material Request Line";
    begin

        MaterialReqLine.SetRange("No.", MatReqNo);
        if not MaterialReqLine.FindSet() then
            Error('Click the "Get Lines" action to retrieve the item from the respective production order. Otherwise, you cannot raise an issue.');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post (Yes/No)", 'OnAfterPost', '', false, false)]
    local procedure OnAfterPost(var TransHeader: Record "Transfer Header"; Selection: Option " ",Shipment,Receipt)
    var
        TransferLine: Record "Transfer Line";
    begin
        TransferLine.SetRange("Document No.", TransHeader."No.");
        if TransferLine.FindSet() then
            TransferLine.ModifyAll("Qty to issue", 0);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post (Yes/No)", 'OnBeforePost', '', false, false)]

    local procedure OnBeforePost(var TransHeader: Record "Transfer Header"; var IsHandled: Boolean; var TransferOrderPostShipment: Codeunit "TransferOrder-Post Shipment"; var TransferOrderPostReceipt: Codeunit "TransferOrder-Post Receipt"; var PostBatch: Boolean; var TransferOrderPost: Enum "Transfer Order Post")
    var
        TransferLine: Record "Transfer Line";
    begin
        if TransHeader."Is Issue" = true then begin
            TransferLine.SetRange("Document No.", TransHeader."No.");
            TransferLine.SetRange("Qty to issue", 0);
            if TransferLine.FindSet() then begin
                TransferLine.ModifyAll("Qty. to Ship", 0);
                TransferLine.ModifyAll("Qty. to Receive", 0);
            end;
        end;
    end;


    procedure CreateTransferOrder(Rec: Record "Material Request Header")
    var
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        MaterialRequest: Record "Material Request Header";
    begin
        MaterialRequest.Copy(Rec);
        CreatedTransferHeader(TransferHeader, MaterialRequest);
        CreateTransferLine(TransferHeader, TransferLine);

        Message('Material Issue is created against this request');
    end;

    local procedure CreatedTransferHeader(var TransferHeader: Record "Transfer Header"; MaterialRequest: Record "Material Request Header")
    var
        InvtSetup: Record "Inventory Setup";
        TransferLine: Record "Transfer Line";
    begin
        InvtSetup.Get();
        TransferHeader.Init();
        TransferHeader.Validate("No.", GetNextNoseriesNo(InvtSetup."Transfer Order Nos."));
        TransferHeader.Insert(true);

        TransferHeader.Validate(RequestNo, MaterialRequest."No.");
        TransferHeader.Validate(Description, MaterialRequest."Request Description");
        TransferHeader.Validate("Transfer-from Code", MaterialRequest."From Location");
        TransferHeader.Validate("Transfer-to Code", MaterialRequest."To Location");

        // CreateTransferLine(TransferHeader, TransferLine);

        TransferHeader.Validate("Dimension Set ID", MaterialRequest."Dimension Set ID");
        TransferHeader."Shortcut Dimension 1 Code" := MaterialRequest."Shortcut Dimension 1 Code";
        TransferHeader."Shortcut Dimension 2 Code" := MaterialRequest."Shortcut Dimension 2 Code";

        TransferHeader.Validate("External Document No.", MaterialRequest."No.");
        TransferHeader.Validate("Source No.", MaterialRequest."Source No.");
        TransferHeader.Validate(SourceType, MaterialRequest."Source Type");
        TransferHeader.Validate(Quantity, MaterialRequest.Quantity);
        TransferHeader.Validate("Is Issue", true);
        TransferHeader.Validate("Direct Transfer", true);
        TransferHeader.Modify(true);
    end;

    local procedure CreateTransferLine(TransferHeader: Record "Transfer Header"; var TransferLine: Record "Transfer Line")
    var
        MaterialRequestLine: Record "Material Request Line";
        LineNo: Integer;
    begin

        MaterialRequestLine.SetRange("No.", TransferHeader.RequestNo);
        if MaterialRequestLine.FindSet() then begin
            repeat

                LineNo += 10000;
                TransferLine.Init();
                TransferLine.Validate("Document No.", TransferHeader."No.");
                TransferLine.Validate("Line No.", LineNo);
                TransferLine.Insert(true);

                TransferLine.Validate("Item No.", MaterialRequestLine."Item No.");
                TransferLine.Validate(RequestNo, MaterialRequestLine."No.");

                TransferLine.Validate(Quantity, MaterialRequestLine.Quantity);
                TransferLine.Validate("Quantity (Base)", MaterialRequestLine."Quantity(Base)");
                TransferLine.Validate("Unit of Measure Code", MaterialRequestLine."Unit of measure");
                TransferLine.Validate("Dimension Set ID", MaterialRequestLine."Dimension Set ID");
                TransferLine."Shortcut Dimension 1 Code" := MaterialRequestLine."Shortcut Dimension 1 Code";
                TransferLine."Shortcut Dimension 2 Code" := MaterialRequestLine."Shortcut Dimension 2 Code";
                TransferLine.Modify(true);
            until MaterialRequestLine.Next() = 0;
        end;
    end;

    local procedure GetNextNoseriesNo(NoSeriesCode: Code[20]): Code[20]
    var
        NoSeriesMgt: Codeunit "No. Series";
    begin
        exit(NoSeriesMgt.GetNextNo(NoSeriesCode));
    end;
}

