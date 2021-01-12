using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Gucera
{
    public partial class CreatePromo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void CreatePromoCode(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            try
            {
                String Pcode = code.Text;
                DateTime PIssueDate = Convert.ToDateTime(IssueDate.Text);
                DateTime PExpDate = Convert.ToDateTime(expDate.Text);
                String Pdiscount = discount.Text;
                SqlCommand createPromoProc = new SqlCommand("AdminCreatePromocode", conn);
                createPromoProc.CommandType = CommandType.StoredProcedure;
                createPromoProc.Parameters.Add(new SqlParameter("@code", Pcode));
                createPromoProc.Parameters.Add(new SqlParameter("@isuueDate", PIssueDate));
                createPromoProc.Parameters.Add(new SqlParameter("@expiryDate", PExpDate));
                createPromoProc.Parameters.Add(new SqlParameter("@discount", Pdiscount));
                createPromoProc.Parameters.Add(new SqlParameter("@adminId", Session["user"]));
                conn.Open();
                createPromoProc.ExecuteNonQuery();

                conn.Close();
                Response.Redirect("AdminHome.aspx");
            }
            
            catch(FormatException)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Cannot create promocode')", true);

            }

        }
    }
}