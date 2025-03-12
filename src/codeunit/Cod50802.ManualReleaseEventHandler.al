codeunit 50802 "Manual Release Event Handler"
{


    // Dragon

    // [EventSubscriber(ObjectType::Table, Database::"Transfer Header", 'OnAfterModifyEvent', '', false, false)]
    // local procedure OnAfterTransferHeaderModify(var Rec: Record "Transfer Header"; RunTrigger: Boolean)
    // begin
    //     if Rec.Status <> Rec.Status::Released then begin
    //         CODEUNIT.Run(CODEUNIT::"Release Transfer Document", Rec);
    //         Commit();
    //     end;
    // end;
}
