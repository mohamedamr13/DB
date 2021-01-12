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
    public partial class IssuePromo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void issuePromocode(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            try
            {
                int student = Int16.Parse(sid.Text);
                String promocode = pid.Text;
                SqlCommand issuePromoProc = new SqlCommand("AdminIssuePromocodeToStudent", conn);
                issuePromoProc.CommandType = CommandType.StoredProcedure;
                issuePromoProc.Parameters.Add("@sid", student);
                issuePromoProc.Parameters.Add("@pid", promocode);
                conn.Open();
                issuePromoProc.ExecuteNonQuery();
                conn.Close();
                Response.Redirect("AdminHome.aspx");

            }
            
            catch (FormatException)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Error')", true);

            }
            catch (Exception)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('please make sure that you entered the ids of an exisiting student and an existing promocode')", true);

            }
        }


    }
}