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
    public partial class certifyStudent : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void certify(object sender, EventArgs e)
        {

            string connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            int id = (int)Session["user"];

            DateTime dt = DateTime.Parse(date.Text);
            int cc = Int32.Parse(cid.Text);
            int ss = Int32.Parse(sid.Text);


            SqlCommand cert = new SqlCommand("InstructorIssueCertificateToStudent", conn);
            cert.CommandType = CommandType.StoredProcedure;


            cert.Parameters.Add(new SqlParameter("@cid", cc));
            cert.Parameters.Add(new SqlParameter("@sid", ss));
            cert.Parameters.Add(new SqlParameter("@insId", id));
            cert.Parameters.Add(new SqlParameter("@issueDate", dt));

            conn.Open();
            cert.ExecuteNonQuery();
            conn.Close();

            Response.Write("Student certified");



        }
    }
}