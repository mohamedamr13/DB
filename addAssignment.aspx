<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="addAssignment.aspx.cs" Inherits="Gucera.addAssignment" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
             <asp:Button ID="Dash" runat="server" OnClick ="dash" Text="Back to Course Manager" /> 
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
            Add Assignment
        
        </div>
        <p>
            Assignment Number
        </p>
        <asp:TextBox ID="number" runat="server"></asp:TextBox>
        <br />
        <p>
            Type
        </p>
        <asp:TextBox ID="type" runat="server"></asp:TextBox>
        <br />
        <p>
            Full Grade </p>
        <asp:TextBox ID="fullGrade" runat="server"></asp:TextBox>
        <br />
        <p>
            Weight
        </p>
        <asp:TextBox ID="weight" runat="server"></asp:TextBox>
        <br />
        <p>
            Deadine
        </p>
        <asp:TextBox ID="deadline" runat="server"></asp:TextBox>
        <br />
        <br />
        <br />
        Content<br />
        <asp:TextBox ID="content" runat="server"></asp:TextBox>
        <br />
        <br />
        <br />
        <asp:Button ID="Button1" runat="server" OnClick ="submit" Text="Add" />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
    </form>
</body>
</html>
