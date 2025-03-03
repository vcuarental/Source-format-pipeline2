trigger AccountDefaultDescription on Account (before insert, before update) {
    // Call the bulk method from AccountOperations
    if (Trigger.isBefore) {
        AccountOperations.setDefaultDescription(Trigger.new);
    }
}