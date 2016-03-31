<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChumbyAddMessage.aspx.cs" Inherits="Chumby_ChumbyAddMessage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Chumby Text Message - Add Message</title>
    
    <style type="text/css">
        html
        {
            padding: 20px;
        }
        .ErrorMessage 
        {
            color: Red;
        }
        .SuccessMessage 
        {
            color: Green;
        }
    </style>

    <script language="javascript" type="text/javascript">
        var MAXMESSAGELENGTH = 200;

        function UpdateCharCount(elem) {
            //alert(elem);
            var remChar = MAXMESSAGELENGTH;

            if(elem != null)
                remChar = MAXMESSAGELENGTH - elem.value.length;

            document.getElementById("charCount").innerHTML = remChar.toString() + " of " + MAXMESSAGELENGTH.toString();
        }
    </script>
</head>
<body style="background-color: White;" onload="UpdateCharCount();">
    <form id="form1" runat="server">
    <div>
        <asp:SiteMapPath ID="SiteMapPath1" runat="server">
        </asp:SiteMapPath>
        <br /><br />
        <p>NOTICE: These messages are not private and this application has no security currently built-in. It is possible to send a message to any Chumby device which is 
            running the MsgTxt widget. <b>Please do not abuse this application.</b> I will need to take this application down and/or add security to this application if there are reports
            of abuse.
        </p>
        <p>To report abuse of this application, please send an email to richteel at teelsys dot com. Please include "TxtMsg Abuse" in the subject line.</p>

        <table>
            <tr>
                <td colspan="2">
                    <asp:Label ID="lblStatus" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblChumby" runat="server" Text="Chumby:" AssociatedControlID="lstChumby"></asp:Label>
                </td>
                <td>
                    <asp:DropDownList ID="lstChumby" runat="server">
                    </asp:DropDownList> Devices are added to this list once the TxtMsg widget has run on the device.
                </td>
            </tr>
            
            <tr>
                <td>
                    <asp:Label ID="lblFrom" runat="server" Text="From:" AssociatedControlID="txtFrom"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtFrom" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblMessage" runat="server" Text="Message:" AssociatedControlID="txtMessage"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtMessage" runat="server" Rows="5" Columns="20" TextMode="MultiLine" onkeyup="UpdateCharCount(this);"></asp:TextBox><br />
                    Characters Remaining: <span id="charCount"></span>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Button ID="cmdSubmit" runat="server" Text="Submit" 
                        onclick="cmdSubmit_Click" />
                </td>
            </tr>
        </table>
        <br />
        <p>It is possible for the Chumby to display images and formatted HTML however this form does not allow you to do that yet. I plan to add support to allow these advanced features.</p>
        <br />
        <p>The TxtMsg widget is availible on the Chumby Industries website at <a href="http://www.chumby.com/guide/widget/TxtMsg" target="_blank">http://www.chumby.com/guide/widget/TxtMsg</a>.</p>
        <br />
        <p>BTW: <u>Richard's Office</u> is my Chumby so you may send a message to me if you want to give me some feedback. If you want a reply, put your Chumby's name in the From or Message.</p>
    </div>
    </form>
</body>
</html>
