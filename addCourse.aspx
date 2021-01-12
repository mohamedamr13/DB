<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="addCourse.aspx.cs" Inherits="Gucera.addCourse" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <br />
            &nbsp;<asp:Button ID="backAddCourse" runat="server" OnClick ="Dash" Text="Dashboard" />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <br />
            <br />
&nbsp; Add Course
            <br />
            <br />
            <br />
            Course Name
        </div>
        <asp:TextBox ID="cName" runat="server"></asp:TextBox>
        <p>
            Credit Hours</p>
        <p>
            <asp:TextBox ID="credit" runat="server"></asp:TextBox>
        </p>
        <p>
            Price
        </p>
        <p>
            <asp:TextBox ID="Price" runat="server"></asp:TextBox>
        </p>
        <asp:Button  ID="submitCourse" runat="server"  onClick="SubmitCourse"  Text="Submit" />
    </form>
</body>
</html>
