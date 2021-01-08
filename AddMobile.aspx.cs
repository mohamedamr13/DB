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
    public partial class AddMobile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void onSave(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            String phone = mobile.Text;
            SqlCommand addMobileProc = new SqlCommand("addMobile", conn);
            addMobileProc.CommandType = CommandType.StoredProcedure;
            addMobileProc.Parameters.Add(new SqlParameter("@ID", Session["user"]));
            addMobileProc.Parameters.Add(new SqlParameter("@mobile_number", phone));
            conn.Open();
            addMobileProc.ExecuteNonQuery();
            conn.Close();

        }

    }
}