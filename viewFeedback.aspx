<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="viewFeedback.aspx.cs" Inherits="Gucera.viewFeedback" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Feedbacks</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <br />
&nbsp;<asp:Button ID="Button1" runat="server" onClick ="bCourses" Text="Back to Course Manager" />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Course Feedbacks<br />
            <br />
        </div>

         <asp:Table ID="f1" runat="server" Width="70%"  BorderColor="Black"
            BorderWidth="2"  CellPadding="5"
            CellSpacing="5"             BackColor="Gainsboro"> 
   <asp:TableHeaderRow 
                runat="server" 
                Font-Bold="true"
                >
                <asp:TableHeaderCell>Comment Number</asp:TableHeaderCell>
                <asp:TableHeaderCell>Number of Likes</asp:TableHeaderCell>
                <asp:TableHeaderCell>Comment</asp:TableHeaderCell>
              

            </asp:TableHeaderRow>
</asp:Table>  
    
    </form>
    </body>
</html>
