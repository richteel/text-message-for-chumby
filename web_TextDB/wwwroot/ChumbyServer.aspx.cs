using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Collections;
using System.IO;
using System.Text;

public partial class Chumby_ChumbyServer : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ChumbyTextMessage chumbyTxtMsg = new ChumbyTextMessage(Request);

        // If we do not have chumbyName and chumbyID we can't go any further
        if (string.IsNullOrEmpty(chumbyTxtMsg.ChumbyID) || string.IsNullOrEmpty(chumbyTxtMsg.ChumbyName))
            return;

        chumbyTxtMsg.UpdateChumbyList();

        ArrayList chumbyMsgList = chumbyTxtMsg.GetMessages();
        StringBuilder results = new StringBuilder();


        string addMessageURL = Request.Url.ToString();
        string chumbyName = Request["ChumbyName"];

        addMessageURL = addMessageURL.Substring(0, addMessageURL.LastIndexOf("/") + 1) + "ChumbyAddMessage.aspx";

        string firstMessage = "<font color=\"#000080\" size=\"16\">Steps to send a message to this widget.</font>"
            + "<ul>"
            + "<li>Go to <font color=\"#0000ff\"><a href=\"" + addMessageURL + "\">" + addMessageURL + "</a></font></li>"
            + "<li>Select \"" + chumbyName + "\" from the Chumby drop-down list</li>"
            + "<li>Enter your name and message</li>"
            + "<li>Click the \"Submit\" button</li>"
            + "</ul>";

        //results.Append(string.Format("{0:MM/dd/yyyy HH:mm:ss}\t{1}\t{2}\r\n", DateTime.Now.ToUniversalTime(), "How to send a Text Message", firstMessage));

        if (chumbyMsgList != null && chumbyMsgList.Count != 0)
        {
            for (int idx = 0; idx < chumbyMsgList.Count; idx++)
            {
                ChumbyMessage currMsg = (ChumbyMessage)chumbyMsgList[idx];

                results.Append(string.Format("{0:MM/dd/yyyy HH:mm:ss}\t{1}\t{2}\r\n", currMsg.MessageDate, currMsg.From, currMsg.Message));
            }
        }

        results.Append(string.Format("{0:MM/dd/yyyy HH:mm:ss}\t{1}\t{2}\r\n", DateTime.Now.ToUniversalTime(), "How to send a Text Message", firstMessage));
        
        Response.ContentType = "text/plain";
        //StreamWriter sw = new StreamWriter(Response.OutputStream, Encoding.UTF8);
        //sw.Write(results.ToString());
        Response.Write(results.ToString());
        Response.End();
    }
}