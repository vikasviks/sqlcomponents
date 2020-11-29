package org.example.store;

import org.example.model.AzaguRaja;
import org.example.model.AzaguRajaReference;
import org.junit.jupiter.api.*;

import java.sql.SQLException;

import static org.example.util.DataSourceProvider.dataSource;

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class AzaguRajaTest {

    private final AzaguRajaReferenceStore azaguRajaReferenceStore;
    private final AzaguRajaStore allInAllAzaguRajaStore;


    AzaguRajaTest() {
        this.azaguRajaReferenceStore = new AzaguRajaReferenceStore(dataSource());
        this.allInAllAzaguRajaStore = new AzaguRajaStore(dataSource());
    }

    @BeforeEach
    void init() throws SQLException {
        this.allInAllAzaguRajaStore.deleteAll();
        this.azaguRajaReferenceStore.deleteAll();
    }

    @Test
    void testAzaguRaja() throws SQLException {

        AzaguRajaReference azagurajaobject = new AzaguRajaReference();
        azagurajaobject.setCode("A110");
        azagurajaobject.setName("Hari");
        this.azaguRajaReferenceStore.insert(azagurajaobject);

        //this is to check mymodel, --> insert by setting parameter.
        AzaguRaja allInAllAzaguRaja = new AzaguRaja();
        allInAllAzaguRaja.setReferenceCode("A110");
        AzaguRaja insertedAzaguRaja = this.allInAllAzaguRajaStore.insert()
                .value(allInAllAzaguRaja).returning();


        Assertions.assertEquals("A110", insertedAzaguRaja.getReferenceCode(), "found successfully");

    }
}