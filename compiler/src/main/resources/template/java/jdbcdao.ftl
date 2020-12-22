<#include "/template/java/jdbcbase.ftl">
<#import "/template/java/columns.ftl" as columns>
package <#if daoPackage?? && daoPackage?length != 0 >${daoPackage}</#if>;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.List;
import java.util.stream.Collectors;

<#assign capturedOutput>
/**
 * Datastore for the table - ${table.tableName}.
 */
public final class ${name}Store${orm.daoSuffix}  {

    private final DataSource dataSource;

    /**
     * Datastore
     */
    public ${name}Store${orm.daoSuffix}(final DataSource theDataSource) {
        this.dataSource = theDataSource;
    }

	<#list orm.methodSpecification as method>
		<#include "/template/java/method/${method}.ftl">
	</#list>

	<#--
	<#if exportedKeys?size != 0>
	public List<${name}> get${name}s(Search${name} search${name}) throws SQLException;
		<#assign a=addImportStatement(javaPackageName+ ".search.Search" + name)>
	</#if>	
	-->	

	private ${name} rowMapper(ResultSet rs) throws SQLException {
        final ${name} ${name?uncap_first} = new ${name}();<#assign index=1>
		<#list properties as property>
		<#assign rsGet = "rs.get" + getJDBCClassName(property.dataType) + "("+ index + ")" >
		${name?uncap_first}.set${property.name?cap_first}(${wrapGet(rsGet,property)});<#assign index = index + 1>
		</#list>
        return ${name?uncap_first};
    }



<#list properties as property>
<#assign a=addImportStatement(property.dataType)>
    <#if property.dataType != "org.json.JSONObject">
    
    public static Column.${property.name?cap_first}Column ${property.name}() {
        return new WhereClause().${property.name}();
    }
    </#if>
</#list>

    public static class WhereClause  extends PartialWhereClause  {
        private WhereClause(){
        }
        private String asSql() {
            return nodes.isEmpty() ? null : nodes.stream().map(node -> {
                String asSql;
                if (node instanceof Column) {
                    asSql = ((Column) node).asSql();
                } else if (node instanceof WhereClause) {
                    asSql = "(" + ((WhereClause) node).asSql() + ")";
                } else {
                    asSql = (String) node;
                }
                return asSql;
            }).collect(Collectors.joining(" "));
        }

        public PartialWhereClause and() {
            this.nodes.add("AND");
            return this;
        }

        public PartialWhereClause  or() {
            this.nodes.add("OR");
            return this;
        }

        public WhereClause  and(final WhereClause  whereClause) {
            this.nodes.add("AND");
            this.nodes.add(whereClause);
            return (WhereClause) this;
        }

        public WhereClause  or(final WhereClause  whereClause) {
            this.nodes.add("OR");
            this.nodes.add(whereClause);
            return (WhereClause) this;
        }
    }

    public static class PartialWhereClause  {

        protected final List<Object> nodes;

        private PartialWhereClause() {
            this.nodes = new ArrayList<>();
        }
<#list properties as property>
<#if property.dataType != "org.json.JSONObject">
        public Column.${property.name?cap_first}Column ${property.name}() {
            Column.${property.name?cap_first}Column query = new Column.${property.name?cap_first}Column("${property.column.columnName}",this);
            this.nodes.add(query);
            return query;
        }
         </#if>
		</#list>

       

        

    }
    public static abstract class Column {

            protected final String columnName;
            private final PartialWhereClause  whereClause ;

            public Column(final String columnName, final PartialWhereClause  whereClause) {
                this.columnName = columnName;
                this.whereClause  = whereClause ;
            }

            protected WhereClause  getWhereClause() {
                return (WhereClause) whereClause ;
            }

            protected abstract String asSql();

            <#list properties as property>
    <#switch property.dataType>
    <#case "java.lang.String">
        <@columns.StringColumn property=property/>
        <#break>
    <#case "java.lang.Character">
        <@columns.CharacterColumn property=property/>
        <#break>
    <#case "java.lang.Integer">
        <@columns.IntegerColumn property=property/>
        <#break>
    <#case "java.lang.Short">
        <@columns.ShortColumn property=property/>
        <#break>
    <#case "java.lang.Byte">
        <@columns.ByteColumn property=property/>
        <#break>
    <#case "java.lang.Long">
        <@columns.LongColumn property=property/>
        <#break>
    <#case "java.lang.Float">
        <@columns.FloatColumn property=property/>
        <#break>
    <#case "java.lang.Double">
        <@columns.DoubleColumn property=property/>
        <#break>
    <#case "java.lang.Boolean">
        <@columns.BooleanColumn property=property/>
        <#break>
    <#case "java.time.LocalDate">
        <@columns.LocalDateColumn property=property/>
        <#break>
    <#case "java.time.LocalTime">
        <@columns.LocalTimeColumn property=property/>
        <#break>
    <#case "java.time.LocalDateTime">
        <@columns.LocalDateTimeColumn property=property/>
        <#break>
    </#switch>
		</#list>

        }
    

}<#assign a=addImportStatement("java.util.ArrayList")><#assign a=addImportStatement("java.time.LocalDate")>
</#assign>
<@importStatements/>

${capturedOutput}