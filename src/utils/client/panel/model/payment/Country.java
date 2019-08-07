package projects.tanks.server.panel.model.payment;

public class Country {

    private String id;
    private String name;

    public Country() {

    }

    public Country(String id, String name) {
	this.id = id;
	this.name = name;
    }

    /**
     * Двухсимвольный идентификатор страны
     * 
     * @return
     */
    public String getId() {
	return id;
    }

    public void setId(String id) {
	this.id = id;
    }

    /**
     * Название страны
     * 
     * @return
     */
    public String getName() {
	return name;
    }

    public void setName(String name) {
	this.name = name;
    }

}
