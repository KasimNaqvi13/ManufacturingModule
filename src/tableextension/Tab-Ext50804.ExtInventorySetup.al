tableextension 50804 "Ext. Inventory Setup" extends "Inventory Setup"
{

    fields
    {
        field(50800; "Material Request Nos."; Code[20])
        {
            Caption = 'Material Request Nos.';
            AccessByPermission = TableData "Material Request Header" = R;
            TableRelation = "No. Series";
        }
    }
}
