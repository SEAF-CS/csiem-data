var wms_layers = [];


        var lyr_GoogleSatellite_0 = new ol.layer.Tile({
            'title': 'Google Satellite',
            'type': 'base',
            'opacity': 1.000000,
            
            
            source: new ol.source.XYZ({
    attributions: ' &middot; <a href="https://www.google.at/permissions/geoguidelines/attr-guide.html">Map data ©2015 Google</a>',
                url: 'https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}'
            })
        });

        var lyr_ESRIGraylight_1 = new ol.layer.Tile({
            'title': 'ESRI Gray (light)',
            'type': 'base',
            'opacity': 1.000000,
            
            
            source: new ol.source.XYZ({
    attributions: ' ',
                url: 'http://services.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}'
            })
        });
var format_MLAUZones_2 = new ol.format.GeoJSON();
var features_MLAUZones_2 = format_MLAUZones_2.readFeatures(json_MLAUZones_2, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_MLAUZones_2 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_MLAUZones_2.addFeatures(features_MLAUZones_2);
var lyr_MLAUZones_2 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_MLAUZones_2, 
                style: style_MLAUZones_2,
                interactive: true,
                title: '<img src="styles/legend/MLAUZones_2.png" /> MLAU Zones'
            });
var format_BOMIDY_3 = new ol.format.GeoJSON();
var features_BOMIDY_3 = format_BOMIDY_3.readFeatures(json_BOMIDY_3, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_BOMIDY_3 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_BOMIDY_3.addFeatures(features_BOMIDY_3);
var lyr_BOMIDY_3 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_BOMIDY_3, 
                style: style_BOMIDY_3,
                interactive: true,
                title: '<img src="styles/legend/BOMIDY_3.png" /> BOM-IDY'
            });
var format_CSMCWQ_4 = new ol.format.GeoJSON();
var features_CSMCWQ_4 = format_CSMCWQ_4.readFeatures(json_CSMCWQ_4, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_CSMCWQ_4 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_CSMCWQ_4.addFeatures(features_CSMCWQ_4);
var lyr_CSMCWQ_4 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_CSMCWQ_4, 
                style: style_CSMCWQ_4,
                interactive: true,
                title: '<img src="styles/legend/CSMCWQ_4.png" /> CSMC-WQ'
            });
var format_DOTTIDE_5 = new ol.format.GeoJSON();
var features_DOTTIDE_5 = format_DOTTIDE_5.readFeatures(json_DOTTIDE_5, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_DOTTIDE_5 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_DOTTIDE_5.addFeatures(features_DOTTIDE_5);
var lyr_DOTTIDE_5 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_DOTTIDE_5, 
                style: style_DOTTIDE_5,
                interactive: true,
                title: '<img src="styles/legend/DOTTIDE_5.png" /> DOT-TIDE'
            });
var format_DPIRDCRP_6 = new ol.format.GeoJSON();
var features_DPIRDCRP_6 = format_DPIRDCRP_6.readFeatures(json_DPIRDCRP_6, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_DPIRDCRP_6 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_DPIRDCRP_6.addFeatures(features_DPIRDCRP_6);
var lyr_DPIRDCRP_6 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_DPIRDCRP_6, 
                style: style_DPIRDCRP_6,
                interactive: true,
                title: '<img src="styles/legend/DPIRDCRP_6.png" /> DPIRD-CRP'
            });
var format_DWERCANEST_7 = new ol.format.GeoJSON();
var features_DWERCANEST_7 = format_DWERCANEST_7.readFeatures(json_DWERCANEST_7, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_DWERCANEST_7 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_DWERCANEST_7.addFeatures(features_DWERCANEST_7);
var lyr_DWERCANEST_7 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_DWERCANEST_7, 
                style: style_DWERCANEST_7,
                interactive: true,
                title: '<img src="styles/legend/DWERCANEST_7.png" /> DWER-CANEST'
            });
var format_DWERCSMOORING_8 = new ol.format.GeoJSON();
var features_DWERCSMOORING_8 = format_DWERCSMOORING_8.readFeatures(json_DWERCSMOORING_8, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_DWERCSMOORING_8 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_DWERCSMOORING_8.addFeatures(features_DWERCSMOORING_8);
var lyr_DWERCSMOORING_8 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_DWERCSMOORING_8, 
                style: style_DWERCSMOORING_8,
                interactive: true,
                title: '<img src="styles/legend/DWERCSMOORING_8.png" /> DWER-CSMOORING'
            });
var format_DWERCSMWQ_9 = new ol.format.GeoJSON();
var features_DWERCSMWQ_9 = format_DWERCSMWQ_9.readFeatures(json_DWERCSMWQ_9, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_DWERCSMWQ_9 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_DWERCSMWQ_9.addFeatures(features_DWERCSMWQ_9);
var lyr_DWERCSMWQ_9 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_DWERCSMWQ_9, 
                style: style_DWERCSMWQ_9,
                interactive: true,
                title: '<img src="styles/legend/DWERCSMWQ_9.png" /> DWER-CSMWQ'
            });
var format_DWERSWANCATCH_10 = new ol.format.GeoJSON();
var features_DWERSWANCATCH_10 = format_DWERSWANCATCH_10.readFeatures(json_DWERSWANCATCH_10, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_DWERSWANCATCH_10 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_DWERSWANCATCH_10.addFeatures(features_DWERSWANCATCH_10);
var lyr_DWERSWANCATCH_10 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_DWERSWANCATCH_10, 
                style: style_DWERSWANCATCH_10,
                interactive: true,
                title: '<img src="styles/legend/DWERSWANCATCH_10.png" /> DWER-SWANCATCH'
            });
var format_DWERSWANEST_11 = new ol.format.GeoJSON();
var features_DWERSWANEST_11 = format_DWERSWANEST_11.readFeatures(json_DWERSWANEST_11, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_DWERSWANEST_11 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_DWERSWANEST_11.addFeatures(features_DWERSWANEST_11);
var lyr_DWERSWANEST_11 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_DWERSWANEST_11, 
                style: style_DWERSWANEST_11,
                interactive: true,
                title: '<img src="styles/legend/DWERSWANEST_11.png" /> DWER-SWANEST'
            });
var format_FPAMQMP_12 = new ol.format.GeoJSON();
var features_FPAMQMP_12 = format_FPAMQMP_12.readFeatures(json_FPAMQMP_12, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_FPAMQMP_12 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_FPAMQMP_12.addFeatures(features_FPAMQMP_12);
var lyr_FPAMQMP_12 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_FPAMQMP_12, 
                style: style_FPAMQMP_12,
                interactive: true,
                title: '<img src="styles/legend/FPAMQMP_12.png" /> FPA-MQMP'
            });
var format_IMOSANMNCTD_13 = new ol.format.GeoJSON();
var features_IMOSANMNCTD_13 = format_IMOSANMNCTD_13.readFeatures(json_IMOSANMNCTD_13, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_IMOSANMNCTD_13 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_IMOSANMNCTD_13.addFeatures(features_IMOSANMNCTD_13);
var lyr_IMOSANMNCTD_13 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_IMOSANMNCTD_13, 
                style: style_IMOSANMNCTD_13,
                interactive: true,
                title: '<img src="styles/legend/IMOSANMNCTD_13.png" /> IMOS-ANMN-CTD'
            });
var format_IMOSBGC_14 = new ol.format.GeoJSON();
var features_IMOSBGC_14 = format_IMOSBGC_14.readFeatures(json_IMOSBGC_14, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_IMOSBGC_14 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_IMOSBGC_14.addFeatures(features_IMOSBGC_14);
var lyr_IMOSBGC_14 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_IMOSBGC_14, 
                style: style_IMOSBGC_14,
                interactive: true,
                title: '<img src="styles/legend/IMOSBGC_14.png" /> IMOS-BGC'
            });
var format_WCBMT_15 = new ol.format.GeoJSON();
var features_WCBMT_15 = format_WCBMT_15.readFeatures(json_WCBMT_15, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_WCBMT_15 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_WCBMT_15.addFeatures(features_WCBMT_15);
var lyr_WCBMT_15 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_WCBMT_15, 
                style: style_WCBMT_15,
                interactive: true,
                title: '<img src="styles/legend/WCBMT_15.png" /> WC-BMT'
            });
var format_WCWAPSDP12_16 = new ol.format.GeoJSON();
var features_WCWAPSDP12_16 = format_WCWAPSDP12_16.readFeatures(json_WCWAPSDP12_16, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_WCWAPSDP12_16 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_WCWAPSDP12_16.addFeatures(features_WCWAPSDP12_16);
var lyr_WCWAPSDP12_16 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_WCWAPSDP12_16, 
                style: style_WCWAPSDP12_16,
                interactive: true,
                title: '<img src="styles/legend/WCWAPSDP12_16.png" /> WCWA-PSDP-1.2'
            });
var format_WCWAPSDPBMT349_17 = new ol.format.GeoJSON();
var features_WCWAPSDPBMT349_17 = format_WCWAPSDPBMT349_17.readFeatures(json_WCWAPSDPBMT349_17, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_WCWAPSDPBMT349_17 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_WCWAPSDPBMT349_17.addFeatures(features_WCWAPSDPBMT349_17);
var lyr_WCWAPSDPBMT349_17 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_WCWAPSDPBMT349_17, 
                style: style_WCWAPSDPBMT349_17,
                interactive: true,
                title: '<img src="styles/legend/WCWAPSDPBMT349_17.png" /> WCWA-PSDP-BMT349'
            });
var format_WWMSP22Light_18 = new ol.format.GeoJSON();
var features_WWMSP22Light_18 = format_WWMSP22Light_18.readFeatures(json_WWMSP22Light_18, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_WWMSP22Light_18 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_WWMSP22Light_18.addFeatures(features_WWMSP22Light_18);
var lyr_WWMSP22Light_18 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_WWMSP22Light_18, 
                style: style_WWMSP22Light_18,
                interactive: true,
                title: '<img src="styles/legend/WWMSP22Light_18.png" /> WWMSP2.2-Light'
            });
var format_WWMSP22Seagrass_19 = new ol.format.GeoJSON();
var features_WWMSP22Seagrass_19 = format_WWMSP22Seagrass_19.readFeatures(json_WWMSP22Seagrass_19, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_WWMSP22Seagrass_19 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_WWMSP22Seagrass_19.addFeatures(features_WWMSP22Seagrass_19);
var lyr_WWMSP22Seagrass_19 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_WWMSP22Seagrass_19, 
                style: style_WWMSP22Seagrass_19,
                interactive: true,
                title: '<img src="styles/legend/WWMSP22Seagrass_19.png" /> WWMSP2.2-Seagrass'
            });
var format_WWMSP51AWAC_20 = new ol.format.GeoJSON();
var features_WWMSP51AWAC_20 = format_WWMSP51AWAC_20.readFeatures(json_WWMSP51AWAC_20, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_WWMSP51AWAC_20 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_WWMSP51AWAC_20.addFeatures(features_WWMSP51AWAC_20);
var lyr_WWMSP51AWAC_20 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_WWMSP51AWAC_20, 
                style: style_WWMSP51AWAC_20,
                interactive: true,
                title: '<img src="styles/legend/WWMSP51AWAC_20.png" /> WWMSP5.1-AWAC'
            });
var format_WWMSP51MET_21 = new ol.format.GeoJSON();
var features_WWMSP51MET_21 = format_WWMSP51MET_21.readFeatures(json_WWMSP51MET_21, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_WWMSP51MET_21 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_WWMSP51MET_21.addFeatures(features_WWMSP51MET_21);
var lyr_WWMSP51MET_21 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_WWMSP51MET_21, 
                style: style_WWMSP51MET_21,
                interactive: true,
                title: '<img src="styles/legend/WWMSP51MET_21.png" /> WWMSP5.1-MET'
            });
var format_WWMSP51WQ_22 = new ol.format.GeoJSON();
var features_WWMSP51WQ_22 = format_WWMSP51WQ_22.readFeatures(json_WWMSP51WQ_22, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_WWMSP51WQ_22 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_WWMSP51WQ_22.addFeatures(features_WWMSP51WQ_22);
var lyr_WWMSP51WQ_22 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_WWMSP51WQ_22, 
                style: style_WWMSP51WQ_22,
                interactive: true,
                title: '<img src="styles/legend/WWMSP51WQ_22.png" /> WWMSP5.1-WQ'
            });
var format_EcologyBenthic_23 = new ol.format.GeoJSON();
var features_EcologyBenthic_23 = format_EcologyBenthic_23.readFeatures(json_EcologyBenthic_23, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_EcologyBenthic_23 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_EcologyBenthic_23.addFeatures(features_EcologyBenthic_23);
var lyr_EcologyBenthic_23 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_EcologyBenthic_23, 
                style: style_EcologyBenthic_23,
                interactive: true,
                title: '<img src="styles/legend/EcologyBenthic_23.png" /> Ecology (Benthic)'
            });
var format_EcologyPlanktonic_24 = new ol.format.GeoJSON();
var features_EcologyPlanktonic_24 = format_EcologyPlanktonic_24.readFeatures(json_EcologyPlanktonic_24, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_EcologyPlanktonic_24 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_EcologyPlanktonic_24.addFeatures(features_EcologyPlanktonic_24);
var lyr_EcologyPlanktonic_24 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_EcologyPlanktonic_24, 
                style: style_EcologyPlanktonic_24,
                interactive: true,
                title: '<img src="styles/legend/EcologyPlanktonic_24.png" /> Ecology (Planktonic)'
            });
var format_Hydrodynamics_25 = new ol.format.GeoJSON();
var features_Hydrodynamics_25 = format_Hydrodynamics_25.readFeatures(json_Hydrodynamics_25, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_Hydrodynamics_25 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_Hydrodynamics_25.addFeatures(features_Hydrodynamics_25);
var lyr_Hydrodynamics_25 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_Hydrodynamics_25, 
                style: style_Hydrodynamics_25,
                interactive: true,
                title: '<img src="styles/legend/Hydrodynamics_25.png" /> Hydrodynamics'
            });
var format_Hydrology_26 = new ol.format.GeoJSON();
var features_Hydrology_26 = format_Hydrology_26.readFeatures(json_Hydrology_26, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_Hydrology_26 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_Hydrology_26.addFeatures(features_Hydrology_26);
var lyr_Hydrology_26 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_Hydrology_26, 
                style: style_Hydrology_26,
                interactive: true,
                title: '<img src="styles/legend/Hydrology_26.png" /> Hydrology'
            });
var format_Light_27 = new ol.format.GeoJSON();
var features_Light_27 = format_Light_27.readFeatures(json_Light_27, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_Light_27 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_Light_27.addFeatures(features_Light_27);
var lyr_Light_27 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_Light_27, 
                style: style_Light_27,
                interactive: true,
                title: '<img src="styles/legend/Light_27.png" /> Light'
            });
var format_Meteorology_28 = new ol.format.GeoJSON();
var features_Meteorology_28 = format_Meteorology_28.readFeatures(json_Meteorology_28, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_Meteorology_28 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_Meteorology_28.addFeatures(features_Meteorology_28);
var lyr_Meteorology_28 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_Meteorology_28, 
                style: style_Meteorology_28,
                interactive: true,
                title: '<img src="styles/legend/Meteorology_28.png" /> Meteorology'
            });
var format_Misc_29 = new ol.format.GeoJSON();
var features_Misc_29 = format_Misc_29.readFeatures(json_Misc_29, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_Misc_29 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_Misc_29.addFeatures(features_Misc_29);
var lyr_Misc_29 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_Misc_29, 
                style: style_Misc_29,
                interactive: true,
                title: '<img src="styles/legend/Misc_29.png" /> Misc'
            });
var format_WaterQualityContaminants_30 = new ol.format.GeoJSON();
var features_WaterQualityContaminants_30 = format_WaterQualityContaminants_30.readFeatures(json_WaterQualityContaminants_30, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_WaterQualityContaminants_30 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_WaterQualityContaminants_30.addFeatures(features_WaterQualityContaminants_30);
var lyr_WaterQualityContaminants_30 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_WaterQualityContaminants_30, 
                style: style_WaterQualityContaminants_30,
                interactive: true,
                title: '<img src="styles/legend/WaterQualityContaminants_30.png" /> Water Quality (Contaminants)'
            });
var format_WaterQualityLight_31 = new ol.format.GeoJSON();
var features_WaterQualityLight_31 = format_WaterQualityLight_31.readFeatures(json_WaterQualityLight_31, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_WaterQualityLight_31 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_WaterQualityLight_31.addFeatures(features_WaterQualityLight_31);
var lyr_WaterQualityLight_31 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_WaterQualityLight_31, 
                style: style_WaterQualityLight_31,
                interactive: true,
                title: '<img src="styles/legend/WaterQualityLight_31.png" /> Water Quality (Light)'
            });
var format_WaterQualityNutrient_32 = new ol.format.GeoJSON();
var features_WaterQualityNutrient_32 = format_WaterQualityNutrient_32.readFeatures(json_WaterQualityNutrient_32, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_WaterQualityNutrient_32 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_WaterQualityNutrient_32.addFeatures(features_WaterQualityNutrient_32);
var lyr_WaterQualityNutrient_32 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_WaterQualityNutrient_32, 
                style: style_WaterQualityNutrient_32,
                interactive: true,
                title: '<img src="styles/legend/WaterQualityNutrient_32.png" /> Water Quality (Nutrient)'
            });
var format_WaterQualityPhysChm_33 = new ol.format.GeoJSON();
var features_WaterQualityPhysChm_33 = format_WaterQualityPhysChm_33.readFeatures(json_WaterQualityPhysChm_33, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_WaterQualityPhysChm_33 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_WaterQualityPhysChm_33.addFeatures(features_WaterQualityPhysChm_33);
var lyr_WaterQualityPhysChm_33 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_WaterQualityPhysChm_33, 
                style: style_WaterQualityPhysChm_33,
                interactive: true,
                title: '<img src="styles/legend/WaterQualityPhysChm_33.png" /> Water Quality (PhysChm)'
            });
var group_DataCategory = new ol.layer.Group({
                                layers: [lyr_EcologyBenthic_23,lyr_EcologyPlanktonic_24,lyr_Hydrodynamics_25,lyr_Hydrology_26,lyr_Light_27,lyr_Meteorology_28,lyr_Misc_29,lyr_WaterQualityContaminants_30,lyr_WaterQualityLight_31,lyr_WaterQualityNutrient_32,lyr_WaterQualityPhysChm_33,],
                                title: "Data Category"});
var group_Program = new ol.layer.Group({
                                layers: [lyr_BOMIDY_3,lyr_CSMCWQ_4,lyr_DOTTIDE_5,lyr_DPIRDCRP_6,lyr_DWERCANEST_7,lyr_DWERCSMOORING_8,lyr_DWERCSMWQ_9,lyr_DWERSWANCATCH_10,lyr_DWERSWANEST_11,lyr_FPAMQMP_12,lyr_IMOSANMNCTD_13,lyr_IMOSBGC_14,lyr_WCBMT_15,lyr_WCWAPSDP12_16,lyr_WCWAPSDPBMT349_17,lyr_WWMSP22Light_18,lyr_WWMSP22Seagrass_19,lyr_WWMSP51AWAC_20,lyr_WWMSP51MET_21,lyr_WWMSP51WQ_22,],
                                title: "Program"});
var group_Basemaps = new ol.layer.Group({
                                layers: [lyr_GoogleSatellite_0,lyr_ESRIGraylight_1,lyr_MLAUZones_2,],
                                title: "Basemaps"});

lyr_GoogleSatellite_0.setVisible(true);lyr_ESRIGraylight_1.setVisible(true);lyr_MLAUZones_2.setVisible(true);lyr_BOMIDY_3.setVisible(true);lyr_CSMCWQ_4.setVisible(true);lyr_DOTTIDE_5.setVisible(true);lyr_DPIRDCRP_6.setVisible(true);lyr_DWERCANEST_7.setVisible(true);lyr_DWERCSMOORING_8.setVisible(true);lyr_DWERCSMWQ_9.setVisible(true);lyr_DWERSWANCATCH_10.setVisible(true);lyr_DWERSWANEST_11.setVisible(true);lyr_FPAMQMP_12.setVisible(true);lyr_IMOSANMNCTD_13.setVisible(true);lyr_IMOSBGC_14.setVisible(true);lyr_WCBMT_15.setVisible(true);lyr_WCWAPSDP12_16.setVisible(true);lyr_WCWAPSDPBMT349_17.setVisible(true);lyr_WWMSP22Light_18.setVisible(true);lyr_WWMSP22Seagrass_19.setVisible(true);lyr_WWMSP51AWAC_20.setVisible(true);lyr_WWMSP51MET_21.setVisible(true);lyr_WWMSP51WQ_22.setVisible(true);lyr_EcologyBenthic_23.setVisible(true);lyr_EcologyPlanktonic_24.setVisible(true);lyr_Hydrodynamics_25.setVisible(true);lyr_Hydrology_26.setVisible(true);lyr_Light_27.setVisible(true);lyr_Meteorology_28.setVisible(true);lyr_Misc_29.setVisible(true);lyr_WaterQualityContaminants_30.setVisible(true);lyr_WaterQualityLight_31.setVisible(true);lyr_WaterQualityNutrient_32.setVisible(true);lyr_WaterQualityPhysChm_33.setVisible(true);
var layersList = [group_Basemaps,group_Program,group_DataCategory];
lyr_MLAUZones_2.set('fieldAliases', {'Unit_Name': 'Unit_Name', 'Name': 'Name', 'Plot_Order': 'Plot_Order', 'BP_Region': 'BP_Region', 'BP_Order': 'BP_Order', });
lyr_BOMIDY_3.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_CSMCWQ_4.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_DOTTIDE_5.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_DPIRDCRP_6.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_DWERCANEST_7.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_DWERCSMOORING_8.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_DWERCSMWQ_9.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_DWERSWANCATCH_10.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_DWERSWANEST_11.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_FPAMQMP_12.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_IMOSANMNCTD_13.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_IMOSBGC_14.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_WCBMT_15.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_WCWAPSDP12_16.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_WCWAPSDPBMT349_17.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_WWMSP22Light_18.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_WWMSP22Seagrass_19.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_WWMSP51AWAC_20.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_WWMSP51MET_21.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_WWMSP51WQ_22.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_EcologyBenthic_23.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_EcologyPlanktonic_24.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_Hydrodynamics_25.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_Hydrology_26.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_Light_27.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_Meteorology_28.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_Misc_29.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_WaterQualityContaminants_30.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_WaterQualityLight_31.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_WaterQualityNutrient_32.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_WaterQualityPhysChm_33.set('fieldAliases', {'Agency_Name': 'Agency_Name', 'Agency_Code': 'Agency_Code', 'Program_Name': 'Program_Name', 'Program_Code': 'Program_Code', 'Tag': 'Tag', 'Data_File_Name': 'Data_File_Name', 'Data_File_Location': 'Data_File_Location', 'Status': 'Status', 'Lat': 'Lat', 'Lon': 'Lon', 'Time_Zone': 'Time_Zone', 'Vertical_Datum': 'Vertical_Datum', 'Station_ID': 'Station_ID', 'Site_Description': 'Site_Description', 'Deployment': 'Deployment', 'Deployment_Position': 'Deployment_Position', 'Vertical_Reference': 'Vertical_Reference', 'Site_Mean_Depth': 'Site_Mean_Depth', 'Bad_Data_Code': 'Bad_Data_Code', 'Email': 'Email', 'Variable_ID': 'Variable_ID', 'DataCategory': 'DataCategory', 'Sampling_Rate': 'Sampling_Rate', 'Date_Format': 'Date_Format', 'Depth_Format': 'Depth_Format', 'Variable_Name': 'Variable_Name', 'QC_Code': 'QC_Code', 'X': 'X', 'Y': 'Y', 'calc_SMD': 'calc_SMD', 'mAHD': 'mAHD', });
lyr_MLAUZones_2.set('fieldImages', {'Unit_Name': 'TextEdit', 'Name': 'TextEdit', 'Plot_Order': 'Range', 'BP_Region': 'TextEdit', 'BP_Order': 'Range', });
lyr_BOMIDY_3.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'Range', 'Site_Description': 'TextEdit', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'Range', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_CSMCWQ_4.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'TextEdit', 'Site_Description': 'TextEdit', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_DOTTIDE_5.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'TextEdit', 'Site_Description': 'TextEdit', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'Range', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_DPIRDCRP_6.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'TextEdit', 'Site_Description': 'TextEdit', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_DWERCANEST_7.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'Range', 'Site_Description': 'Range', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_DWERCSMOORING_8.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'Range', 'Site_Description': 'TextEdit', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_DWERCSMWQ_9.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'Range', 'Site_Description': 'Range', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_DWERSWANCATCH_10.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'Range', 'Site_Description': 'Range', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_DWERSWANEST_11.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'Range', 'Site_Description': 'Range', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_FPAMQMP_12.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'TextEdit', 'Site_Description': 'TextEdit', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_IMOSANMNCTD_13.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'Range', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'TextEdit', 'Site_Description': 'TextEdit', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_IMOSBGC_14.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'Range', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'TextEdit', 'Site_Description': 'TextEdit', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_WCBMT_15.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'TextEdit', 'Site_Description': 'TextEdit', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_WCWAPSDP12_16.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'TextEdit', 'Site_Description': 'TextEdit', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_WCWAPSDPBMT349_17.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'TextEdit', 'Site_Description': 'TextEdit', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_WWMSP22Light_18.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'TextEdit', 'Site_Description': 'TextEdit', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_WWMSP22Seagrass_19.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'TextEdit', 'Site_Description': 'TextEdit', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_WWMSP51AWAC_20.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'TextEdit', 'Site_Description': 'TextEdit', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'Range', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_WWMSP51MET_21.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'TextEdit', 'Site_Description': 'TextEdit', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_WWMSP51WQ_22.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'TextEdit', 'Site_Description': 'TextEdit', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'Range', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_EcologyBenthic_23.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'TextEdit', 'Site_Description': 'TextEdit', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_EcologyPlanktonic_24.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'Range', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'TextEdit', 'Site_Description': 'TextEdit', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_Hydrodynamics_25.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'TextEdit', 'Site_Description': 'TextEdit', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_Hydrology_26.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'Range', 'Site_Description': 'Range', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_Light_27.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'TextEdit', 'Site_Description': 'TextEdit', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_Meteorology_28.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'TextEdit', 'Site_Description': 'TextEdit', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_Misc_29.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'TextEdit', 'Site_Description': 'TextEdit', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_WaterQualityContaminants_30.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'TextEdit', 'Site_Description': 'TextEdit', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_WaterQualityLight_31.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'TextEdit', 'Site_Description': 'TextEdit', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_WaterQualityNutrient_32.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'TextEdit', 'Site_Description': 'TextEdit', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_WaterQualityPhysChm_33.set('fieldImages', {'Agency_Name': 'TextEdit', 'Agency_Code': 'TextEdit', 'Program_Name': 'TextEdit', 'Program_Code': 'TextEdit', 'Tag': 'TextEdit', 'Data_File_Name': 'TextEdit', 'Data_File_Location': 'TextEdit', 'Status': 'TextEdit', 'Lat': 'TextEdit', 'Lon': 'TextEdit', 'Time_Zone': 'TextEdit', 'Vertical_Datum': 'TextEdit', 'Station_ID': 'TextEdit', 'Site_Description': 'TextEdit', 'Deployment': 'TextEdit', 'Deployment_Position': 'TextEdit', 'Vertical_Reference': 'TextEdit', 'Site_Mean_Depth': 'TextEdit', 'Bad_Data_Code': 'TextEdit', 'Email': 'TextEdit', 'Variable_ID': 'TextEdit', 'DataCategory': 'TextEdit', 'Sampling_Rate': 'TextEdit', 'Date_Format': 'TextEdit', 'Depth_Format': 'TextEdit', 'Variable_Name': 'TextEdit', 'QC_Code': 'TextEdit', 'X': 'TextEdit', 'Y': 'TextEdit', 'calc_SMD': 'TextEdit', 'mAHD': 'TextEdit', });
lyr_MLAUZones_2.set('fieldLabels', {});
lyr_BOMIDY_3.set('fieldLabels', {});
lyr_CSMCWQ_4.set('fieldLabels', {});
lyr_DOTTIDE_5.set('fieldLabels', {});
lyr_DPIRDCRP_6.set('fieldLabels', {});
lyr_DWERCANEST_7.set('fieldLabels', {});
lyr_DWERCSMOORING_8.set('fieldLabels', {});
lyr_DWERCSMWQ_9.set('fieldLabels', {});
lyr_DWERSWANCATCH_10.set('fieldLabels', {});
lyr_DWERSWANEST_11.set('fieldLabels', {});
lyr_FPAMQMP_12.set('fieldLabels', {});
lyr_IMOSANMNCTD_13.set('fieldLabels', {});
lyr_IMOSBGC_14.set('fieldLabels', {});
lyr_WCBMT_15.set('fieldLabels', {});
lyr_WCWAPSDP12_16.set('fieldLabels', {});
lyr_WCWAPSDPBMT349_17.set('fieldLabels', {});
lyr_WWMSP22Light_18.set('fieldLabels', {});
lyr_WWMSP22Seagrass_19.set('fieldLabels', {});
lyr_WWMSP51AWAC_20.set('fieldLabels', {});
lyr_WWMSP51MET_21.set('fieldLabels', {});
lyr_WWMSP51WQ_22.set('fieldLabels', {});
lyr_EcologyBenthic_23.set('fieldLabels', {});
lyr_EcologyPlanktonic_24.set('fieldLabels', {});
lyr_Hydrodynamics_25.set('fieldLabels', {});
lyr_Hydrology_26.set('fieldLabels', {});
lyr_Light_27.set('fieldLabels', {});
lyr_Meteorology_28.set('fieldLabels', {});
lyr_Misc_29.set('fieldLabels', {});
lyr_WaterQualityContaminants_30.set('fieldLabels', {});
lyr_WaterQualityLight_31.set('fieldLabels', {});
lyr_WaterQualityNutrient_32.set('fieldLabels', {});
lyr_WaterQualityPhysChm_33.set('fieldLabels', {});
lyr_WaterQualityPhysChm_33.on('precompose', function(evt) {
    evt.context.globalCompositeOperation = 'normal';
});