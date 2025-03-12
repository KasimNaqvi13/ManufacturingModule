page 50802 "Material Request Subform"
{
    ApplicationArea = All;
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "Material Request Line";
    AutoSplitKey = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                    Editable = false;
                    Caption = 'No.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                    Caption = 'Request Quantity';
                    Editable = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies the value of the Due Date field.', Comment = '%';
                    Editable = false;
                }
                field("Unit of Measure"; Rec."Unit of measure")
                {
                    ToolTip = 'Specifies the value of the Unit of measure field.', Comment = '%';
                    Editable = false;
                    Caption = 'Unit of Measure Code';
                }
                field("Varient Code"; Rec."Varient Code")
                {

                }
            }
        }

    }
    actions
    {
        area(Processing)
        {

            action("Get Lines")
            {
                ApplicationArea = All;
                Caption = 'Get Lines';
                Image = GetLines;
                ToolTip = 'Gets the lines from production order';

                trigger OnAction()
                var
                    MaterialReqHeader: Record "Material Request Header";
                    TransferCodeunit: Codeunit RequestandIssueManagement;
                begin
                    if MaterialReqHeader.Get(Rec."No.") then begin
                        TransferCodeunit.TransferComponentsToRequest(MaterialReqHeader."Source No.", MaterialReqHeader);
                    end;
                end;
            }
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;

                action(Dimensions)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ToolTip = 'View or edit dimensions for this line.';

                    trigger OnAction()
                    begin
                        Rec."Dimension Set ID" := DimMgt.EditDimensionSet(Rec."Dimension Set ID", Rec.Description);
                        Rec.Modify(true);
                    end;
                }
            }
        }
    }
    var
        DimMgt: Codeunit DimensionManagement;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        //Rec.Reset();
        //Rec.DeleteAll();
    end;
}

