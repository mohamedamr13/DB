import java.io.Serializable;
import java.sql.Date;

public class Page implements Serializable {
	protected String id;
	protected Object min;
	protected Object max;
	protected boolean isFull;
    private static final long serialVersionUID = 6529685098267757691L;


	public Page() {
		// TODO Auto-generated constructor stub
	}

	public Page(Object min, Object max, String id) {
		this.min = min;
		this.max = max;
		this.id = id;

	}
	
	public String  getId() {
		return id;
	}

	
	
}
