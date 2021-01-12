using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace Gucera
{
    public partial class AddMobile : System.Web.UI.Page
    {
        String phone = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }
        protected void onSave(object sender, EventArgs e)
        {
            try
            {
                string connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
                SqlConnection conn = new SqlConnection(connStr);
                phone = mobile.Text;
                SqlCommand checker = new SqlCommand("select id,mobileNumber from UserMobileNumber", conn);
                
                checker.CommandType = CommandType.Text;
                conn.Open();
                SqlDataReader rdr = checker.ExecuteReader(CommandBehavior.CloseConnection);
                while (rdr.Read())
                {
                    String check = rdr.GetString(rdr.GetOrdinal("mobileNumber"));
                    int id = rdr.GetInt32(rdr.GetOrdinal("id"));
                    if (check.Equals(phone) && id.Equals(Session["user"]))

                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('you already saved this mobile number')", true);
                        return;

                    }
                }
                SqlCommand addMobileProc = new SqlCommand("addMobile", conn);
                addMobileProc.CommandType = CommandType.StoredProcedure;
                addMobileProc.Parameters.Add(new SqlParameter("@ID", Session["user"]));
                addMobileProc.Parameters.Add(new SqlParameter("@mobile_number", phone));
                conn.Open();
                addMobileProc.ExecuteNonQuery();
                conn.Close();
                Label l = new Label();
                l.Text = "Mobile added succesfully";
                Literal lit = new Literal();
                lit.Text = "<br />";
                form1.Controls.Add(lit);
                form1.Controls.Add(lit);
                form1.Controls.Add(l);
            }
            catch (Exception)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('please enter all required data correctly')", true);

            }

        }

        protected void addMoreMob(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            phone = " ";
            mobile.Text = "";
        }




    }
}