<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewAssignmentContent.aspx.cs" Inherits="Gucera.ViewAssignmentContent" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .auto-style4 {
            position: absolute;
            top: 124px;
            left: 12px;
            z-index: 1;
        }
        .auto-style5 {
            position: absolute;
            top: 152px;
            left: 197px;
            z-index: 1;
        }
        .auto-style6 {
            position: absolute;
            top: 176px;
            left: 12px;
            z-index: 1;
        }
        .auto-style7 {
            position: absolute;
            top: 205px;
            left: 10px;
        }
        .auto-style8 {
            position: absolute;
            top: 64px;
            left: 490px;
            z-index: 1;
        }
        </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <br />
            <br />
            <br />
            <br />
            Course ID
            <asp:TextBox ID="cid" runat="server" CssClass="auto-style4"></asp:TextBox>
        </div>
        <p>
            <br />
        <asp:Button ID="view" runat="server" CssClass="auto-style5" onClick="ViewAssignContent" Text="Enter" />
            <br />
        </p>
        <p>
             <br />
             <asp:Label ID="Label1" runat="server" CssClass="auto-style6" Text="Instructor ID"></asp:Label>
             <asp:TextBox ID="insid" runat="server" CssClass="auto-style7" style="z-index: 1"></asp:TextBox>
             <br />
             <br />
             <br />
        <asp:Literal runat="server" id="msg" EnableViewState="false" />
              <br />
             <br />  
            
            </p>


    <div>

                  
            <asp:GridView ID="contentTable" runat="server" CssClass="auto-style8" ShowHeaderWhenEmpty="True">
            </asp:GridView>

    </div>
    </form>
</body>
</html>
