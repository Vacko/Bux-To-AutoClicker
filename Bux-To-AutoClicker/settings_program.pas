unit settings_program;

interface

const
 Pname    = 'Bux.To AutoClicker';
 Pversion = '3.3';
 PBy      = 'By Vacko';

 Servers_Names : array[0..0] of Pchar = ('Bux.to'
                                        );
 Servers_Links : array[0..0] of Pchar = ('http://bux.to/'
                                        );
 Servers_Image : array[0..0] of Pchar = ('http://www.bux.to/captcha/imagebuilder.php'
                                        );
 Servers_UImag : array[0..0] of Pchar = ('bux_to.png'
                                        );
                                        
 bux_Cmessage  = 'No more links. Work is Done !';
 bux_login_in  = 'Logged in as';
 bux_to_logpa  = 'Your username and/or password could not be verified.';
 bux_to_logpa2 = 'Your username and/or password is wrong';
 but_to_image  = 'Invalid verification code entered.';
 Key1          = '\Software\Microsoft\Windows\CurrentVersion\Run';

implementation

end.
