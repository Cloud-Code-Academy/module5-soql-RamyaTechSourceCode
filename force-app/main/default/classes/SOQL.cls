/**
 * The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
 * It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
 *
 * This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
 * a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
 * records, and manage data volume using the LIMIT keyword.
 *
 * Topics covered in this class include:
 * - Understanding the structure of a SOQL query.
 * - Crafting basic SELECT statements in SOQL.
 * - Applying filters using the WHERE clause in SOQL.
 * - Fetching related records using Relationship queries.
 * - Controlling the amount of data retrieved using the LIMIT keyword.
 *
 * Users of this class can expect to gain a solid understanding of SOQL in Apex and
 * be prepared to handle data retrieval tasks in Salesforce development.
 *
 * @author Your Name
 */

public with sharing class SOQL {
	/**
	 * Question 1
	 * Update/Uncomment the template code to create a method
	 * Returns all leads from Salesforce Org
	 * @return List of all leads with Id, LastName, Company, Phone, Email
	 * Update the corresponding test class and testGetAllLeads method to cover this method
	 */
	public static List<Lead> getAllLeads() 
	{
	  List<Lead> leads;
	  try 
	  {
		leads = [SELECT Id,LastName,Company,Phone,Email 
				 FROM Lead 
				 WITH SECURITY_ENFORCED];
	  } 
	  catch (DmlException e) 
	  {
		System.debug('The following exception has occured : ' + e.getMessage());
	  }
	  return leads;
	}

	/**
	 * Question 2
	 * Update/Uncomment the template code to create a method
	 * Returns all contacts with first name of John.
	 * @return A list of Contact records.
	 * Update the corresponding test class and testGetContactsByFirstName method to cover this method
	 */
	public static List<Contact> getContactsByFirstName(String firstName) 
	{
	 List<Contact> contacts;
	  try 
	  {
		contacts = [SELECT Id,FirstName,LastName,Name 
					FROM Contact 
					WHERE firstName= :firstName
				    WITH SECURITY_ENFORCED];
	  } 
	  catch (DmlException e) 
	  {
		System.debug('The following exception has occured : ' + e.getMessage());
	  }
	  return contacts;
	}

	/**
	 * Question 3
	 * Update/Uncomment the template code to create a method
	 * Returns the Contact Id for all contacts with last name of Smith or Jones
	 * @return A list of Contact Ids.
	 * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
	 */
	public static List<Id> getContactIdsByLastName(List<String> lastNames) 
	{
	  List<Id> ids = new List<Id>();
	  try 
	  {
		List<Contact> contactIds = [SELECT Id 
									FROM Contact 
									WHERE LastName in :lastNames 
									WITH SECURITY_ENFORCED];
		for(Contact con : contactIds){
			ids.add(con.id);
		}
	  } 
	  catch (DmlException e) 
	  {
		System.debug('The following exception has occured : ' + e.getMessage());
	  }
	  return ids;
	}


	/**
	 * Question 4
	 * Update/Uncomment the template code to create a method
	 * Returns List of closed won opportunities for a specific Account.
	 * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A list of Opportunities with important opportunities fields
	 * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
	 */
	public static List<Opportunity> getClosedWonOpportunityCountByAccount(Id accountID) 
	{
	  String stageValue = 'Closed Won';
	  List<Opportunity> oppo;
	  try 
	  {
		 oppo = [SELECT Name,StageName,CloseDate,Amount,AccountID 
		 		 FROM Opportunity 
				 WHERE StageName = :stageValue and AccountID=: accountID 
				 WITH SECURITY_ENFORCED];
	  } 
	  catch (DmlException e) 
	  {
		System.debug('The following exception has occured : ' + e.getMessage());
	  }
	  return oppo;
	}

	/**
	 * Question 5
	 * Update/Uncomment the template code to create a method
	 * Returns the total count of Account records.
	 * @return The Integer count of Account records.
	 * Update the corresponding test class and testGetAccountCount method to cover this method
	 */
	public static Integer getAccountCount()
	{
	  Integer accCount;
	  try 
	  {
		List<AggregateResult> countResult= [SELECT count(Id) cnt 
											FROM Account 
											WITH SECURITY_ENFORCED];
		accCount = (Integer)countResult[0].get('cnt');
	  } 
	  catch (DmlException e) 
	  {
		System.debug('The following exception has occured : ' + e.getMessage());
	  }
	  return accCount;
	}
	/**
	 * Question 6
	 * Update/Uncomment the template code to create a method
	 * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
	 * @return A map of Task Ids to Task records.
	 * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
	 */
	 public static Map<Id,Task> getTasksDueNextWeek()
	 {
	   Map<Id,Task> taskMap;
	   try 
	   {
		 List<Task> taskResult= [SELECT Id,Subject 
		 						FROM Task 
								WHERE ActivityDate <= NEXT_N_DAYS:7 
								WITH SECURITY_ENFORCED];
		 taskMap = new Map<Id,Task>(taskResult);
	   } 
	   catch (DmlException e) 
	   {
		 System.debug('The following exception has occured : ' + e.getMessage());
	   }
	   return taskMap;
	 }

	/**
	 * Question 7
	 * Update/Uncomment the template code to create a method
	 * Retrieves all Contacts that have a example.com domain in their Email.
	 * @return A list of Contact records.
	 * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
	 */
	public static List<Contact> getContactsByEmailDomain() 
	{
	  String domain = '%example.com';
	  List<Contact> con;
	  try 
	  {
		 con = [SELECT Id,Name,Email 
		 		FROM Contact 
				WHERE Email like :domain 
				WITH SECURITY_ENFORCED];
	  } 
	  catch (DmlException e) 
	  {
		System.debug('The following exception has occured : ' + e.getMessage());
	  }
	  return con;
	}

	/**
	 * Question 8
	 * Retrieves all Opportunities that have a specific keyword in their Name.
	 * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
	 * @param keyword The keyword to search for in the Opportunity Name.
	 * @return A list of Opportunity records.
	 */
	public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) 
	{
		List<Opportunity> opp;
		try 
		{
			opp = [SELECT Id,Name,StageName 
				   FROM Opportunity 
				   WHERE Name LIKE :'%'+ keyword + '%' 
				   WITH SECURITY_ENFORCED];
		} 
		catch (DmlException e) 
		{
		  System.debug('The following exception has occured : ' + e.getMessage());
		}
		return opp; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 9
	 * Retrieves all Cases that Case Origin is not Web or Email or Blank
	 * @return A list of Case records.
	 */
	public static List<Case> getFilterCaseOrigins() 
	{
		List<Case> allCase;
		try 
		{
			Set<String> caseOrigin= new Set<String>{'Web', 'Email', ''};
			allCase = [SELECT Id,Status,Type,Origin 
			           FROM Case 
					   WHERE Origin Not In : caseOrigin 
					   WITH SECURITY_ENFORCED];
		} 
		catch (DmlException e) 
		{
		  System.debug('The following exception has occured : ' + e.getMessage());
		}
		return allCase; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 10
	 * Update/Uncomment the template code to create a method
	 * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
	 * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
	 * @param leadSource The Lead Source to search for.
	 * @param keyword The keyword to search for in the Lead Title.
	 * @return A list of Lead records.
	 * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
	 */
	public static List<Lead> getLeadsBySourceOrTitle(String leadSource,String title) 
	{
		List<Lead> allLead;
		try 
		{
			allLead = [SELECT Id,LeadSource,Title,LastName,Company,Phone,Email 
			           FROM Lead 
					   WHERE leadSource = :leadSource or Title like :'%'+title+'%' 
					   WITH SECURITY_ENFORCED];
		} 
		catch (DmlException e) 
		{
		  System.debug('The following exception has occured : ' + e.getMessage());
		}
		return allLead; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 11
	 * Returns the names of all Contacts associated with an Account.
	 * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A list of Contact LastName.
	 */
	public static List<String> getContactNamesByAccount(Id accountId) {
		// Create a list to hold the Contact LastNames
		List<String> lastNames = new List<String>();
		try 
		{
			// Query the Contacts
			List<Contact> contacts = [SELECT Id,LastName,FirstName,Phone,Email 
									  FROM Contact 
								      WHERE AccountID = :accountId 
								      WITH SECURITY_ENFORCED];
			// Loop through each Contact and add the LastName to the list
			for (Contact con : contacts) {
			  lastNames.add(con.LastName);
			}
		} 
		catch (DmlException e) 
		{
		  System.debug('The following exception has occured : ' + e.getMessage());
		}
		// Return the list of Contact LastNames
		return lastNames; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 12
	 * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
	 * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for the found opportunities
	 * @param stage The Stage value to filter Opportunities.
	 * @return The total revenue.
	 */
	public static Decimal getTotalRevenueByStage(String stage) {
		Decimal totalRevenue;
		try 
		{
			// Use AggregateQuery to get the total revenue
			List<AggregateResult> result = [SELECT Sum(Amount) cnt 
									        FROM opportunity 
								            WHERE StageName = :stage or Amount > 10000 
								            WITH SECURITY_ENFORCED];
		    totalRevenue = 	(Decimal)result[0].get('cnt');	
		} 
		catch (DmlException e) 
		{
		  System.debug('The following exception has occured : ' + e.getMessage());
		}
		// Return the total revenue
		return totalRevenue; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 13
	 * Retrieves the first 10 Accounts ordered by Name.
	 * @return A list of the first 10 Accounts ordered by Name.
	 */
	public static List<Account> getFirstTenAccounts() {
		List<Account> accResult;
		try 
		{
			accResult = [SELECT id,Name
						 FROM Account 
						 ORDER BY Name
						 LIMIT 10];
    	} 
		catch (DmlException e) 
		{
		  System.debug('The following exception has occured : ' + e.getMessage());
		}
		return accResult; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 14
	 * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
	 * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
	 */
	public static List<Opportunity> getHighValueOpportunities() {
		List<Opportunity> oppResult;
		try 
		{
            oppResult = [SELECT Id,CloseDate,Name,AccountId,Amount,StageName
						 FROM Opportunity 
						 WHERE Amount > 100000 
						 ORDER BY CloseDate
						 LIMIT 5];
        } 
		catch (DmlException e) 
		{
		  System.debug('The following exception has occured : ' + e.getMessage());
		}
		return oppResult; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 15
	 * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
	 * @return A list of Contacts
	 */
	public static List<Contact> getBirthdateContacts() {
		List<Contact> contacts;
		try 
		{
            contacts = [SELECT Id,LastName,FirstName,Birthdate
						FROM Contact 
						ORDER BY Birthdate DESC
						LIMIT 3];
        } 
		catch (DmlException e) 
		{
		  System.debug('The following exception has occured : ' + e.getMessage());
		}
		return contacts; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 16
	 * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
	 * @return A list of Cases
	 */
	public static List<Case> getCasesWithStatus() {
		List<Case> cases;
		String status = 'Open';
		try 
		{
            cases = [SELECT Id,Status,CreatedDate
					 FROM Case 
					 WHERE Status =: status
					 ORDER BY CreatedDate 
					 LIMIT 10
					 OFFSET 5];
        } 
		catch (DmlException e) 
		{
		  System.debug('The following exception has occured : ' + e.getMessage());
		}
		return cases; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 17
	 * Returns Set of Case Ids for a specific Account.
	 * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A set of Case Ids.
	 */
	public static Set<Id> getCaseIdsByAccount(Id accountId) {
		// Create a set to hold the Case Ids
		Set<Id> caseIds = new Set<Id>();
		List<Case> cases;
		try 
		{
			// Query the Cases
            cases = [SELECT Id,AccountID
					 FROM Case 
					 WHERE AccountID =: accountId
					 WITH SECURITY_ENFORCED];
			// Loop through each Case and add the Id to the set
			for(Case c : cases)
			{
				caseIds.add(c.Id);
        	} 
		}
		catch (DmlException e) 
		{
		    System.debug('The following exception has occured : ' + e.getMessage());
		}
		return caseIds; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 18
	 * Return Map of Account Ids to Account Names Not in a specific Country.
	 * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
	 * @param country The country to filter Accounts.
	 * @return A map of Account Ids to Account Names.
	 */
	public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
		// Create a map to hold the Account Ids to Account Names
		Map<Id, String> accountIdsToNames = new Map<Id, String>();
		try 
		{
			// Query the Accounts
			List<Account> accounts = [SELECT id,Name
									  FROM Account 
									  WHERE BillingCountry != :country
									  wITH SECURITY_ENFORCED];
			// Loop through each Account and add the Id and Name to the map
			for(Account acc : accounts)
			{
				accountIdsToNames.put(acc.id,acc.Name);
			}
		} 
		catch (DmlException e) 
		{
		    System.debug('The following exception has occured : ' + e.getMessage());
		}
		return accountIdsToNames; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 19
	 * Retrieves the Account Name for a given Contact.
	 * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
	 * @param contactId The Id of the Contact.
	 * @return The Account Name of the Contact.
	 */
	public static String getAccountNameForContact(String contactId) {
		String accName;
		try 
		{
			List<Contact> contacts = [SELECT id,Account.Name
									  FROM Contact 
									  WHERE id=:contactId
									  WITH SECURITY_ENFORCED];
			accName = contacts[0].Account.Name;
		} 
		catch (DmlException e) 
		{
		    System.debug('The following exception has occured : ' + e.getMessage());
		}
		return accName; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 20
	 * Returns single Account that has related opportunities in the same query
	 * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
	 * @param accountId The ID of the Account.
	 * @return An Account record with related Opportunities.
	 */
	public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {
		Account accounts;
		try 
		{
			accounts = [SELECT id,name,
			            (SELECT id,name
						FROM Opportunities) 
						FROM Account
						WHERE Id=:accountId
						WITH SECURITY_ENFORCED];
		} 
		catch (DmlException e) 
		{
		    System.debug('The following exception has occured : ' + e.getMessage());
		}
		return accounts; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 21
	 * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
	 * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
	 * @param Account Id
	 * @return List of contacts with the same Mailing State as the Account Billing State
	 */
	public static List<Contact> getAccountsWithContactsByState(Id accountId) {
		List<Contact> contacts;
		try 
		{
			// Query the Account
			Account accounts = [SELECT id,name,billingState
			            		FROM Account
						        WHERE Id=:accountId
						        WITH SECURITY_ENFORCED];
							
			// Query the Contacts
			contacts = [SELECT id
				        FROM Contact
			            WHERE MailingState =:accounts.billingState];
		} 
		catch (DmlException e) 
		{
		    System.debug('The following exception has occured : ' + e.getMessage());
		}
		return contacts; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 22
	 * Extracts email domains from them leads, then finds Accounts with matching website domains
	 * If Lead Email = test@test.com return account with website = www.test.com
	 * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
	 * @param A set of Lead Ids.
	 * @return A list of Accounts with matching email domains.
	 */
	public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) 
	{
		List<Account> accounts;
		String subDomain = 'www.';
		try 
		{
			// Query the Leads
            List<Lead> leads = [SELECT Email
							   FROM Lead
							   WHERE id in :leadIds
							   WITH SECURITY_ENFORCED];
			// Create a set of email domains from the Leads
			Set<String> emailDomains = new Set<String>();
			// Loop through each Lead
			for(Lead l : leads)
			{
				// Get the email from the Lead
				// Check if the email is not null
				if(l.Email != null)
				{
					// Add the email domain to the set
					emailDomains.add(subDomain + l.Email.split('@')[1]);
				}
			}
			
			// Query the Accounts
			accounts = [SELECT Id,Website
						FROM Account
						WHERE Website like : emailDomains
						WITH SECURITY_ENFORCED];
		}
		catch (DmlException e) 
		{
		    System.debug('The following exception has occured : ' + e.getMessage());
		}
		return accounts; // Replace null with the variable you used to store the result
	}


	/**
	 * Question 23
	 * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
	 * Adds a randomized number between 1 to 3 to the quantity of each line item.
	 * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
	 * @param Original Opportunity Id
	 * @param List of cloned Opportunity Ids
	 */
	public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) 
	{
		try 
		{
			// Query the original Opportunity Line Items
			List<OpportunityLineItem> oppLineItems = [SELECT id, Quantity,PricebookEntryId,UnitPrice
													  FROM OpportunityLineItem
													  WHERE OpportunityId = :origOppId
													  WITH SECURITY_ENFORCED];
			// Create a list to hold the new line items
			List<OpportunityLineItem> newLineItems = new List<OpportunityLineItem>();
			// Generate a random number between 1 and 3
			Integer randomNum =(Integer)Math.floor(Math.random() * 3) + 1;
			// Loop through each cloned Opportunity Id
			for(Id cloneId : cloneOppIds)
			{
				// Loop through each original line item
				for(OpportunityLineItem lineItem : oppLineItems)
				{
					// Clone the original line item and add the random number to the quantity
					newLineItems.add(new OpportunityLineItem(OpportunityId = cloneId,
														    PricebookEntryId = lineItem.PricebookEntryId,
															UnitPrice = lineItem.UnitPrice,
															Quantity = lineItem.Quantity + randomNum));
				}
			}
			// Insert the new line items
			insert newLineItems;
    	}
		catch (DmlException e) 
		{
			System.debug('The following exception has occured : ' + e.getMessage());
		}
	}

	/**
	 * Question 24
	 * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
	 * @return A list of filtered Opportunity
	 */
	public static List<Opportunity> getOpportunityDetailsForClosedWon() 
	{
		List<Opportunity> opp;
		String stageName ='Closed Won';
		try 
		{
			opp = [SELECT Name,Account.Name,Owner.Name,AccountID
				  FROM Opportunity
				  WHERE StageName =: stageName];
		} 
		catch (DmlException e) 
		{
			System.debug('The following exception has occured : ' + e.getMessage());
		}
		return opp; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 25
	 * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to the Contact on the associated Account with the alphabetically first first name.
	 * Example: if there are two Contacts on the Account, "Billy" and "Abby," the 'Primary_Contact__c' will be set to "Abby."
	 */
	public static void setPrimaryContact() 
	{
		try 
		{
			//Use the getOpportunityDetailsForClosedWon() method to get the Opportunities
			List<Opportunity> opportunities = getOpportunityDetailsForClosedWon();
			// Create a set of Account Ids from the Opportunities
			Set<Id> ids = new Set<Id>();
			for(Opportunity opp : opportunities)
			{
				ids.add(opp.AccountId);
			}
			// Query the Contacts
			List<Contact> contacts = [SELECT Id,FirstName,LastName,AccountID
									  FROM Contact
									  WHERE AccountID IN : ids
									  WITH SECURITY_ENFORCED
									  ORDER BY FirstName ASC];
			
			// Loop through each Contact and add the Account Id and Contact to the map
			Map<Id,Contact> accountToContactMap = new Map<Id,Contact>();
			for(Contact con : contacts)
			{
				accountToContactMap.put(con.AccountId,contacts[0]);
			}
			// Loop through each Opportunity
			for(Opportunity opp : opportunities)
			{
				// Update the Opportunity primary contact from accountToContactMap
				opp.primary_contact__c = accountToContactMap.get(opp.AccountId).id;
			}
			// Update the Opportunities
			update opportunities;
		} 
		catch (DmlException e) 
		{
			System.debug('The following exception has occured : ' + e.getMessage());
		}
	}
}
