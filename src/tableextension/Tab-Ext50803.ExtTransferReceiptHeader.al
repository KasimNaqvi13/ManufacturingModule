tableextension 50803 ExtTransferReceiptHeader extends "Transfer Receipt Header"
{
    fields
    {
        field(50800; "IssueNo."; Code[20])
        {
            Caption = 'IssueNo.';
            DataClassification = ToBeClassified;
        }
        field(50801; "Issue Description"; Text[100])
        {
            Caption = 'Issue Description';
            DataClassification = ToBeClassified;
        }
        field(50802; "Request No."; Code[20])
        {
            Caption = 'Request No.';
            DataClassification = ToBeClassified;
        }
        field(50803; "IsPosted"; boolean)
        {

        }
    }
}
