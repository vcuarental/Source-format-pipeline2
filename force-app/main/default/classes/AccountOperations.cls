public class AccountOperations {
    
    public static Account setDefaultDescription(Account acc) {
        if(acc.Description == null || acc.Description.trim().length() == 0) {
            acc.Description = 'Default description';
        }
        return acc;
    }
    
    public static Account setDefaultPhone(Account acc) {
        if(acc.Phone == null || acc.Phone.trim().length() == 0) {
            acc.Phone = '1234567890';
        }
        return acc;
    }
    
    public static Account setDefaultURL(Account acc) {
        if(acc.Website == null || acc.Website.trim().length() == 0) {
            acc.Website = 'www.mydefaultsite.com';
        }
        return acc;
    }
    
    public static List<Account> setDefaultValues(List<Account> accList) {
        if(accList == null || accList.isEmpty()) {
            return new List<Account>();
        }
        
        List<Account> updatedAccounts = new List<Account>();
        for(Account acc : accList) {
            Account updatedAcc = acc;
            updatedAcc = setDefaultDescription(updatedAcc);
            updatedAcc = setDefaultPhone(updatedAcc);
            updatedAcc = setDefaultURL(updatedAcc);
            updatedAccounts.add(updatedAcc);
        }
        return updatedAccounts;
    }
}