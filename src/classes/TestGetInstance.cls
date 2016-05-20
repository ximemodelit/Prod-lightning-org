public class TestGetInstance{ 
public string display{get; set;} 
public TestGetInstance(){ 
String currentRequestURL = URL.getSalesforceBaseUrl().getHost(); 
display='https://'+currentRequestURL; 
}
}