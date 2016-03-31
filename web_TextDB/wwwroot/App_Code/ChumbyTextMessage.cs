using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Collections;
using System.IO;
using System.Text;

public struct ChumbyDevice : IComparable
{
    public string ChumbyId;
    public string ChumbyName;
    public DateTime Added;
    public DateTime LastAccessed;

    public int CompareTo(object obj)
    {
        ChumbyDevice c2 = (ChumbyDevice)obj;

        return ChumbyName.CompareTo(c2.ChumbyName);
    }
}

public struct ChumbyMessage : IComparable
{
    public DateTime MessageDate;
    public string From;
    public string Message;

    public int CompareTo(object obj)
    {
        ChumbyMessage c2 = (ChumbyMessage)obj;

        return -1 * MessageDate.CompareTo(c2.MessageDate);
    }
}

/// <summary>
/// Summary description for ChumbyTextMessage
/// </summary>
public class ChumbyTextMessage
{
    #region Private Constants
    /*** START ***/
    private const int DEFAULTMAXMESSAGES = -1;
    private const int DEFAULTMAXDAYS = -1;
    private const string PARMDELIMITERITEMS = "|";
    private const string PARMDELIMITERKEYVAL = "=";
    private const string CHUMBYDEVICEFILEPREFIX = "~/TextMsg_Files/";
    private const string CHUMBYDEVICEFILE = CHUMBYDEVICEFILEPREFIX + "DeviceList.txt";
    /*** END ***/
    #endregion

    #region Private Fields
    /*** START ***/
    // Information which must be sent with request
    private string chumbyID;
    private string chumbyName;
    private int maxDays;
    private int maxMessages;
    private Hashtable parameters;
    private string password;
    private string userName;

    private string lastErrorMsg = "";

    private string chumbyListFile;
    /*** END ***/
    #endregion

    #region Public Properties
    /*** START ***/
    public string ChumbyID
    {
        get { return chumbyID; }
        set { chumbyID = value; }
    }

    public string ChumbyName
    {
        get { return chumbyName; }
        set { chumbyName = value; }
    }

    public int MaxDays
    {
        get { return maxDays; }
        set { maxDays = value; }
    }

    public int MaxMessages
    {
        get { return maxMessages; }
        set { maxMessages = value; }
    }

    public Hashtable Parameters
    {
        get { return parameters; }
        set { parameters = value; }
    }

    public string Password
    {
        get { return password; }
        set { password = value; }
    }

    public string UserName
    {
        get { return userName; }
        set { userName = value; }
    }

    public string LastErrorMsg
    {
        get
        {
            string retVal = lastErrorMsg;

            lastErrorMsg = "";

            return retVal; 
        }
    }
    /*** END ***/
    #endregion

    #region Constructor
    /*** START ***/
	public ChumbyTextMessage()
    {
        this.ChumbyID = "";
        this.ChumbyName = "";
        this.MaxDays = DEFAULTMAXDAYS;       // -1 == All
        this.MaxMessages = DEFAULTMAXMESSAGES;   // -1 == All
        this.Parameters = null;
        this.UserName = "";
        this.Password = "";

        chumbyListFile = HttpContext.Current.Server.MapPath(CHUMBYDEVICEFILE);
    }

    public ChumbyTextMessage(string ChumbyID, string ChumbyName, int MaxDays, int MaxMessages, Hashtable Parameters, string UserName, string Password)
    {
        this.ChumbyID = ChumbyID;
        this.ChumbyName = ChumbyName;
        this.MaxDays = MaxDays;
        this.MaxMessages = MaxMessages;
        this.Parameters = Parameters;
        this.UserName = UserName;
        this.Password = Password;

        chumbyListFile = HttpContext.Current.Server.MapPath(CHUMBYDEVICEFILE);
    }

    public ChumbyTextMessage(HttpRequest PageRequest)
    {
        string _maxMessages = "";
        string _maxDays = "";
        string _paramaters = "";

        chumbyListFile = HttpContext.Current.Server.MapPath(CHUMBYDEVICEFILE);

        // 1. Read in request information
        if (PageRequest.Form.Count > 0)
        {
            chumbyName = PageRequest.Form["ChumbyName"] != null ? PageRequest.Form["ChumbyName"].ToString() : chumbyName;
            chumbyID = PageRequest.Form["ChumbyID"] != null ? PageRequest.Form["ChumbyID"].ToString() : chumbyID;
            _maxMessages = PageRequest.Form["MaxMessages"] != null ? PageRequest.Form["MaxMessages"].ToString() : _maxMessages;
            _maxDays = PageRequest.Form["MaxDays"] != null ? PageRequest.Form["MaxDays"].ToString() : _maxDays;
            userName = PageRequest.Form["UserName"] != null ? PageRequest.Form["UserName"].ToString() : userName;
            password = PageRequest.Form["Password"] != null ? PageRequest.Form["Password"].ToString() : password;
            _paramaters = PageRequest.Form["Paramaters"] != null ? PageRequest.Form["Paramaters"].ToString() : _paramaters;
        }
        else if (PageRequest.QueryString.Count > 0)
        {
            chumbyName = PageRequest.QueryString["ChumbyName"] != null ? PageRequest.QueryString["ChumbyName"].ToString() : chumbyName;
            chumbyID = PageRequest.QueryString["ChumbyID"] != null ? PageRequest.QueryString["ChumbyID"].ToString() : chumbyID;
            _maxMessages = PageRequest.QueryString["MaxMessages"] != null ? PageRequest.QueryString["MaxMessages"].ToString() : _maxMessages;
            _maxDays = PageRequest.QueryString["MaxDays"] != null ? PageRequest.QueryString["MaxDays"].ToString() : _maxDays;
            userName = PageRequest.QueryString["UserName"] != null ? PageRequest.QueryString["UserName"].ToString() : userName;
            password = PageRequest.QueryString["Password"] != null ? PageRequest.QueryString["Password"].ToString() : password;
            _paramaters = PageRequest.QueryString["Paramaters"] != null ? PageRequest.QueryString["Paramaters"].ToString() : _paramaters;
        }
        else  // We were given nothing to work with so quit
        {
            return;
        }

        // 2. Assign non-string values
        if (!int.TryParse(_maxMessages, out maxMessages))
            maxMessages = DEFAULTMAXMESSAGES;

        if (!int.TryParse(_maxDays, out maxDays))
            maxDays = DEFAULTMAXDAYS;


        if (!string.IsNullOrEmpty(_paramaters))
        {
            string[] items = _paramaters.Split(new string[] { PARMDELIMITERITEMS }, StringSplitOptions.RemoveEmptyEntries);

            for (int i = 0; i < items.Length; i++)
            {
                string[] pairs = items[i].Split(new string[] { PARMDELIMITERKEYVAL }, StringSplitOptions.RemoveEmptyEntries);

                if (pairs.Length == 2 && !string.IsNullOrEmpty(pairs[0]))
                {
                    if (parameters == null)
                        parameters = new Hashtable();

                    parameters.Add(pairs[0], pairs[1]);
                }
                else if (pairs.Length == 1 && !string.IsNullOrEmpty(pairs[0]))
                {
                    if (parameters == null)
                        parameters = new Hashtable();

                    parameters.Add(pairs[0], "");
                }
            }
        }
    }
    /*** END ***/
    #endregion

    #region Private Methods
    /*** START ***/
    private void CreateDeviceListFile()
    {
        if (!string.IsNullOrEmpty(chumbyListFile) && !File.Exists(chumbyListFile))
        {
            System.IO.StreamWriter deviceFile = new System.IO.StreamWriter(chumbyListFile);
            deviceFile.WriteLine(string.Format("{0}\t{1}\t{2}\t{3}", "ChumbyID", "ChumbyName", "Added", "LastAccessed"));
            //deviceFile.WriteLine(string.Format("{0}\t{1}\t{2:MM/dd/yyyy HH:mm:ss}\t{3:MM/dd/yyyy HH:mm:ss}", chumbyID, chumbyName, DateTime.Now, DateTime.Now));
            deviceFile.Close();
            deviceFile.Dispose();
        }
    }

    private int GetChumbyIdIndex(ArrayList ChumbyList, string ChumbyIdToFind)
    {
        int retVal = -1;

        for (int i = 0; i < ChumbyList.Count; i++)
        {
            ChumbyDevice curDevice = (ChumbyDevice)ChumbyList[i];

            if (curDevice.ChumbyId == ChumbyIdToFind)
            {
                retVal = i;
                break;
            }
        }

        return retVal;
    }

    private void SaveDeviceListFile(ArrayList ChumbyList)
    {
        if (File.Exists(chumbyListFile))
            File.Delete(chumbyListFile);

        if (!File.Exists(chumbyListFile))
        {
            System.IO.StreamWriter deviceFile = new System.IO.StreamWriter(chumbyListFile);
            deviceFile.WriteLine(string.Format("{0}\t{1}\t{2}\t{3}", "ChumbyID", "ChumbyName", "Added", "LastAccessed"));

            for (int i = 0; i < ChumbyList.Count; i++)
            {
                ChumbyDevice chumbyItem = (ChumbyDevice)ChumbyList[i];

                deviceFile.WriteLine(string.Format("{0}\t{1}\t{2}\t{3}", chumbyItem.ChumbyId, chumbyItem.ChumbyName, chumbyItem.Added, chumbyItem.LastAccessed));
            }

            deviceFile.Close();
            deviceFile.Dispose();
        }
    }
    /*** END ***/
    #endregion

    #region Public Methods
    /*** START ***/
    public ArrayList GetChumbyList()
    {
        ArrayList retVal = new ArrayList();

        if (!File.Exists(chumbyListFile))
            return null;

        System.IO.StreamReader deviceFile = new System.IO.StreamReader(chumbyListFile);
        int lineNumber = 0;

        while (deviceFile.Peek() >= 0)
        {
            string line = deviceFile.ReadLine();

            if (lineNumber > 0) // First line is labels
            {
                string[] value = line.Split(new string[] { "\t" }, StringSplitOptions.RemoveEmptyEntries);

                if (value.Length == 4)
                {
                    ChumbyDevice currentItem = new ChumbyDevice();

                    currentItem.ChumbyId = value[0];
                    currentItem.ChumbyName = value[1];
                    currentItem.Added = DateTime.Parse(value[2]);
                    currentItem.LastAccessed = DateTime.Parse(value[3]);

                    retVal.Add(currentItem);
                }
            }

            lineNumber++;
        }

        deviceFile.Close();
        deviceFile.Dispose();

        retVal.Sort();

        return retVal;
    }

    public ArrayList GetMessages()
    {
        ArrayList retVal = new ArrayList();
        string deviceMessageFile = HttpContext.Current.Server.MapPath(CHUMBYDEVICEFILEPREFIX + this.ChumbyID + ".txt");

        if (!File.Exists(deviceMessageFile))
            return null;

        System.IO.StreamReader messageFile = new System.IO.StreamReader(deviceMessageFile);
        int lineNumber = 0;

        while (messageFile.Peek() >= 0)
        {
            string line = messageFile.ReadLine();
            DateTime minDate = DateTime.Now.ToUniversalTime();
            minDate = minDate.AddDays(-1 * this.MaxDays);

            if (lineNumber > 0) // First line is labels
            {
                string[] value = line.Split(new string[] { "\t" }, StringSplitOptions.RemoveEmptyEntries);

                if (value.Length == 3)
                {
                    ChumbyMessage currentMessage = new ChumbyMessage();

                    currentMessage.MessageDate = DateTime.Parse(value[0]);
                    currentMessage.From = value[1];
                    currentMessage.Message = value[2];

                    if (this.MaxDays < 0 || currentMessage.MessageDate >= minDate)
                        retVal.Add(currentMessage);
                }
            }

            lineNumber++;
        }

        messageFile.Close();
        messageFile.Dispose();

        retVal.Sort();

        if (this.MaxMessages > 0 && retVal.Count > this.MaxMessages)
        {
            for (int r = retVal.Count - 1; r >= this.MaxMessages; r--)
            {
                retVal.RemoveAt(r);
            }
        }


        return retVal;
    }

    public bool SaveMessage(string ChumbyID, string From, string Message)
    {
        bool retVal = false;

        if (string.IsNullOrEmpty(ChumbyID))
            return retVal;

        try
        {
            string deviceMessageFile = HttpContext.Current.Server.MapPath(CHUMBYDEVICEFILEPREFIX + ChumbyID + ".txt");
            bool fileExists = File.Exists(deviceMessageFile);
            StreamWriter swDeviceMessageFile = new StreamWriter(deviceMessageFile, true, Encoding.UTF8);

            if (!fileExists)
                swDeviceMessageFile.WriteLine("DateTime\tFrom\tMessage");

            swDeviceMessageFile.WriteLine(string.Format("{0:MM/dd/yyyy HH:mm:ss}\t{1}\t{2}", DateTime.Now.ToUniversalTime(), From, Message.Replace("\r\n", "<br />").Replace("\r", "<br />").Replace("\n", "<br />")));

            swDeviceMessageFile.Close();
            swDeviceMessageFile.Dispose();

            retVal = true;
        }
        catch(Exception ex)
        {
            lastErrorMsg = "ERROR: Failed to save message to file. (" + ex.Message + ")";
        }

        return retVal;
    }

    public void UpdateChumbyList()
    {
        CreateDeviceListFile();

        if (!File.Exists(chumbyListFile))
        {
            return;
        }

        ArrayList chumbyList = GetChumbyList();
        ChumbyDevice currentChumby = new ChumbyDevice();
        currentChumby.ChumbyId = this.ChumbyID;
        currentChumby.ChumbyName = this.ChumbyName;
        currentChumby.Added = DateTime.Now.ToUniversalTime();
        currentChumby.LastAccessed = DateTime.Now.ToUniversalTime();

        int currentChumbyListIndex = GetChumbyIdIndex(chumbyList, chumbyID);

        if (currentChumbyListIndex == -1)
        {
            chumbyList.Add(currentChumby);
        }
        else
        {
            currentChumby = (ChumbyDevice)chumbyList[currentChumbyListIndex];
            currentChumby.ChumbyName = this.ChumbyName;
            currentChumby.LastAccessed = DateTime.Now.ToUniversalTime();
            chumbyList[currentChumbyListIndex] = currentChumby;
        }

        SaveDeviceListFile(chumbyList);
    }
    /*** END ***/
    #endregion
}