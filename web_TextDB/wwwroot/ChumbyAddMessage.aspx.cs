using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Collections;

public partial class Chumby_ChumbyAddMessage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        lblStatus.Text = "&nbsp;";

        if (!Page.IsPostBack)
        {
            ChumbyTextMessage chumbyTxtMsg = new ChumbyTextMessage();
            ArrayList chumbyList = chumbyTxtMsg.GetChumbyList();

            if (chumbyList != null)
            {
                for (int i = 0; i < chumbyList.Count; i++)
                {
                    ChumbyDevice chumbyItem = (ChumbyDevice)chumbyList[i];

                    lstChumby.Items.Add(new ListItem(chumbyItem.ChumbyName, chumbyItem.ChumbyId));
                }
            }

            ListItem promptItem = new ListItem("-- Select a Chumby --", "-1");

            lstChumby.Items.Insert(0, promptItem);
        }
    }

    protected void cmdSubmit_Click(object sender, EventArgs e)
    {
        ChumbyTextMessage chumbyTxtMsg = new ChumbyTextMessage();

        lblStatus.Text = "Failed to add message to queue: Chumby, From, and Message are required";
        lblStatus.CssClass = "ErrorMessage";

        if (lstChumby.SelectedIndex > 0 && !string.IsNullOrEmpty(lstChumby.SelectedValue) && !string.IsNullOrEmpty(txtFrom.Text) && !string.IsNullOrEmpty(txtMessage.Text))
        {
            if (chumbyTxtMsg.SaveMessage(lstChumby.SelectedValue, txtFrom.Text, txtMessage.Text))
            {
                lblStatus.Text = "Success: Message added to queue.";
                lblStatus.CssClass = "SuccessMessage";
                txtMessage.Text = "";
            }
            else
            {
                lblStatus.Text = "Error: Message was not added to queue. (Unknown Error)\r\n"
                    + "<!--   " + chumbyTxtMsg.LastErrorMsg + "   -->";
            }
        }
    }
}