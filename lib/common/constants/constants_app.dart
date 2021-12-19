/*
    Created by Shitab Mir on 16 August 2021
 */

class AppConstants {

  // Constant values
  static const cropTitleFieldStringMaximumLength = 40;
  static const cropDescriptionFieldStringMaximumLength = 300;
  static const cropTypeFieldStringMaximumLength = 100;
  static const fishSpeciesFieldStringMaximumLength = 50;
  static const fishScientificFieldStringMaximumLength = 50;
  static const fishDescriptionFieldStringMaximumLength = 300;

  // Regex
  static const String specialCharacterRegex = '[\\=+.,()/!?@><#^&*{}";:_`~%|-]';
  static const String onlyEnglishNumericsRegex = '[0-9]';

  // Constants
  static const String login = "LOGIN";
  static const String sendOtpAllCaps = "SEND OTP";
  static const String resetPasswordAllCaps = "RESET PASSWORD";
  static const String resendAllCaps = "RESEND";
  static const String submitAllCaps = "SUBMIT";
  static const String forgotPasswordAllCaps = "FORGOT PASSWORD";
  static const String forgotPassword = "Forgot Password";
  static const String requestForOtp = "Request for Otp";
  static const String createNewPassword = "Create new password";

  //logout related
  static const String logoutAllCaps = 'LOGOUT';
  static const String logout = 'Log Out';
  static const String exit = 'Exit';
  static const String wannaLogout = 'Do you want to Log Out?';
  static const String wannaExit = 'Do you want to Exit the App?';
  static const String cancel = 'Cancel';


  // Connection Status
  static const CONNECTION_STATUS_CONNECTED = "Connected";
  static const CONNECTION_STATUS_CONNECTING = "Connecting";
  static const CONNECTION_STATUS_NOT_CONNECTED = "Not Connected";
  static const CONNECTION_STATUS_FAILED = "Connection Failed";
  static const CONNECTION_STATUS_DISCONNECTED = "Connection Disconnected";
  // Units & Fields
  static const UNIT_TEMPERATURE = '  C ';
  static const TEMPERATURE = 'Temp';
  static const EC = 'EC';
  static const UNIT_EC = '  mg/L ';
  static const PH = 'pH';
  static const UNIT_PH = '  pH ';
  static const TDS = 'TDS';
  static const UNIT_TDS = '  ppt ';
  static const SALINITY = 'Sal';
  static const UNIT_SALINITY = '  dS/m ';
  // Page Titles
  static const String cropList = "Crop List";
  static const String fishList = "Fish List";
  static const String cropStatusMonitor = "Crop Status Monitor";

  static const String scanToAddTank = "Scan To Select Tank";
  static const String scanToAddGrowBag = "Scan To Add GrowBag";
  static const String scanToAddTankGrowBag = "Scan To Add Tank/GrowBag";
  static const String enterGrowBagId = "Enter GrowBag Id.";
  //error
  static const String somethingWentWrong = 'Something Went Wrong!';

  //weather Api constant parameter
  static const lat = 23;
  static const lon = 90;
  static const exclude = ["hourly,minutely"];
  static const units = "metric";
  static const appId = "e85006abea0146e6212e331c33807007";

  static const String SUBMIT = 'SUBMIT';
  static const String UPDATE = 'UPDATE';
  static const addNewTank = 'Add New Tank/GrowBag';
  static const updateTank = 'Update Tank/GrowBag';
  static const addCrop = 'Add Crop';

  ///bottom nav
  static const greenHouse = 'GreenHouse';
  static const aquaCulture = 'AquaCulture';

  //crop name input field
  static const String cropTitleInputFieldLabel = "Crop Name";
  static const String cropTitleInputFieldHint = "Crop Name";
  static const String cropTitleInputFieldNoInputFoundError = "No Crop Name Found";
  static const String cropTitleInputFieldLengthError = "Write the Crop Title in $cropTitleFieldStringMaximumLength characters";

  //crop description input field
  static const String cropDescriptionInputFieldLabel = "Crop Description";
  static const String cropDescriptionInputFieldHint = "Crop Description";
  static const String cropDescriptionInputFieldLengthError = "Write the Crop Description in $cropDescriptionFieldStringMaximumLength characters";

  //crop type input field
  static const String cropTypeInputFieldLabel = "Crop Type";
  static const String cropTypeInputFieldHint = "Crop Type";
  static const String cropTypeInputFieldLengthError = "Write the Crop Type in $cropTypeFieldStringMaximumLength characters";

  //Fish species name input field
  static const String fishSpeciesNameInputFieldLabel = "Species Name";
  static const String fishSpeciesNameInputFieldHint = "Species Name";
  static const String fishSpeciesNameInputFieldNoInputFoundError = "No Species Name Found";
  static const String fishSpeciesNameInputFieldLengthError = "Write the Fish Species Name in $fishSpeciesFieldStringMaximumLength characters";

  //Fish Scientific name input field
  static const String fishScientificNameInputFieldLabel = "Scientific Name";
  static const String fishScientificNameInputFieldHint = "Scientific Name";
  static const String fishScientificNameInputFieldNoInputFoundError = "No Scientific Name Found";
  static const String fishScientificNameInputFieldLengthError = "Write the Fish Scientific Name in $fishScientificFieldStringMaximumLength characters";

  //Fish description input field
  static const String fishDescriptionInputFieldLabel = "Description";
  static const String fishDescriptionInputFieldHint = "Description";
  static const String fishDescriptionInputFieldNoInputFoundError = "No Description Name Found";
  static const String fishDescriptionInputFieldLengthError = "Write the Fish Description in $fishDescriptionFieldStringMaximumLength characters";

  //Cultivation Time month input field
  static const String cultivationTimeMonthInputFieldLabel = "Cultivation Time (Days)";
  static const String cultivationTimeMonthInputFieldHint = "Cultivation Time (Days)";
  static const String cultivationTimeMonthInputFieldNoInputFoundError = "No Cultivation Time month Found";

  //Water Parameters input field
  static const String cwaterParametersInputFieldNoInputFoundError = "No Crop Name Found";

  //email input field
  static const String emailInputFieldLabel = "Email";
  static const String emailInputFieldHint = "Enter your Email";
  static const String emailInputFieldNoInputFoundError = 'No Email Found';
  static const String emailInputFieldValidationError = 'Please enter valid Email Address';
  static const String emailInputFieldValidationPattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  //password input field
  static const String passwordInputFieldLabel = "Password";
  static const String passwordInputFieldHint = "Enter your Password";
  static const String passwordInputFieldNoInputFoundError = "No Password Found";

  //repeat password input field
  static const String rePasswordInputFieldLabel = "Confirm Password";
  static const String rePasswordInputFieldHint = "Enter your Password again";
  static const String rePasswordInputFieldNoInputFoundError = "No Password Found";
  static const String rePasswordInputFieldNotMatchError = "Password Not Match";

  //otp input field
  static const String otpInputFieldLabel = "Otp Code";
  static const String otpInputFieldHint = "Enter your Otp Code";
  static const String otpInputFieldNoInputFoundError = "Otp Code not Found";
  static const String otpInputFieldLengthError = "Otp Code must be within 4 digit";

  // Crop Status Feed
  static const String addMore = "Add More";
  static const String noThanks = 'No Thanks';
  static const String addAnotherOne = "Want to Add another one?";
  static const String infoSuccessfullyAdded = 'Info Successfully Added';

}