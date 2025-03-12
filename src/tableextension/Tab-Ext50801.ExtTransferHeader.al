tableextension 50801 "Ext.Transfer Header" extends "Transfer Header"
{
    fields
    {
        field(50800; "Is Issue"; Boolean)
        {
            Caption = 'To Issue';
            DataClassification = ToBeClassified;
        }
        field(50801; RequestNo; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Request No.';
        }
        field(50802; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Requested Quantity';
        }
        field(50803; Description; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Request Description';
        }
        field(50804; "Source No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50805; SourceType; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Production Order Type';
            OptionMembers = "Released production order","Assembly Order","Production Order","Sales Order";
        }
    }
}
