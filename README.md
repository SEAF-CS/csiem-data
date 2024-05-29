# CSIEM Environmental Information Management



The goal of the CSIEM Environmental Information Management framework, as presented herein, is to allow compatibility, inter-operability and between crticial data assets, and version control as is required for the development of a comprehensive and integrated modelling platform.

The framework can be viewed as three separate systems:

Data Collation
Data Governance & Reporting
Data Integration
The relationship between the various iniatives, the CSIEM Environmental Information Management framework, and downstream model applications are outlined schematically below.



![CSIEM Environmental Information Management](https://github.com/AquaticEcoDynamics/csiem-data/wiki/images/Information_Management.png "CSIEM Environmental Information Management")


## Data Collation


The aim of the data collation step is to bring data together in a co-ordinated way. Data that is sourced and collated from various government agencies, researchers and industry groups is stored in a “data lake” in their raw format. Each data provider is assigned a unique agency identifier, and datasets are also grouped based on the main programs or iniatives the collection was associated with. Raw data is stored in a rigid folder structure based on these two identifiers :

```
Agency/Program/ < ... data-sets ...>
```

![CSIEM Data Collation](https://github.com/AquaticEcoDynamics/csiem-data/wiki/images/data_collation.png "CSIEM Data Collation")


For more information, see the [The Cockburn Sound Integrated Ecosystem Model Manual](https://aquaticecodynamics.github.io/csiem-science/index.html)
