<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="viewAss.aspx.cs" Inherits="Gucera.viewAss" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <br />
            <asp:Button ID="Button1" runat="server" onClick ="dash" Text="Back to Course Manager" />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            Assignments<br />
            <br />
        </div>
       
    </form>
  <asp:Table ID="a1" runat="server" Width="70%"  BorderColor="Black"
            BorderWidth="2"  CellPadding="5"
            CellSpacing="5"             BackColor="Gainsboro"> 
   <asp:TableHeaderRow 
                runat="server" 
                Font-Bold="true"
                >
                <asp:TableHeaderCell>Course</asp:TableHeaderCell>
                <asp:TableHeaderCell>Student</asp:TableHeaderCell>
                <asp:TableHeaderCell>Assignment Type</asp:TableHeaderCell>
                <asp:TableHeaderCell>Assignment Number</asp:TableHeaderCell>
                <asp:TableHeaderCell>Grade scored</asp:TableHeaderCell>


            </asp:TableHeaderRow>
</asp:Table>  
</body>
</html>
