<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="certifyStudent.aspx.cs" Inherits="Gucera.certifyStudent" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;             <asp:Button ID="Dash" runat="server" OnClick ="dash" Text="Back to Dashboard" />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            Issue Certificate To Student<br />
            <br />
            <br />
            &nbsp;&nbsp;Student ID<br />
        </div>
&nbsp;
        <asp:TextBox ID="sid" runat="server"></asp:TextBox>
        <p>
            Issue Date</p>
        <p>
&nbsp;
            <asp:TextBox ID="date" runat="server"></asp:TextBox>
        </p>
        <p>
            <asp:Button ID="cert" runat="server" OnClick="certify" Text="Submit" />
        </p>
    </form>
</body>
</html>
