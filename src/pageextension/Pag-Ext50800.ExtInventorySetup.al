pageextension 50800 "Ext. Inventory Setup" extends "Inventory Setup"
{
    layout
    {
        addafter("Transfer Order Nos.")
        {
            field("Material Request Nos."; Rec."Material Request Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the number series that will be used to assign numbers to material request orders.';
                Importance = Promoted;
                Visible = true;
            }
        }
    }
}
