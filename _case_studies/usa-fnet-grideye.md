---
title: "USA &mdash; FNET/GridEye Wide-Area Frequency Monitoring"
slug: usa-fnet-grideye
description: "FNET/GridEye &mdash; a distributed, low-cost frequency monitoring network providing real-time situational awareness across the US power grid."
country: United States
sector: energy
status: published
nav_active: case-studies

# Hero
subtitle: "FNET/GridEye is a wide-area frequency monitoring network using low-cost, GPS-synchronised Frequency Disturbance Recorders (FDRs) to provide real-time situational awareness of power grid dynamics across the United States."
breadcrumb_sector_label: Energy
breadcrumb_sector_filter: energy
hero_tags:
  - Power Grid
  - Wide-Area Monitoring
  - Distributed Sensing
  - Real-Time

# Stats bar
stats:
  - { value: "Nationwide", label: "Deployment" }
  - { value: "Low-cost FDRs", label: "Sensor Type" }
  - { value: "GPS-synced", label: "Synchronisation" }
  - { value: "Real-time", label: "Monitoring" }

# Infobox
infobox:
  title: "Quick Facts &mdash; FNET/GridEye"
  items:
    - { label: "Last reviewed", value: "March 2026 (RQ)" }
    - { label: "Infrastructure", value: "Energy &mdash; FNET/GridEye" }
    - { label: "Focus", value: "Wide-area frequency monitoring" }
    - { label: "Owner", value: "Academic-industry collaboration" }
    - { label: "Location", value: "United States" }

# Homepage card
card:
  category: "Energy &bull; United States"
  short_title: "FNET/GridEye Wide-Area Frequency Monitoring"
  short_desc: "A distributed, low-cost frequency monitoring network providing real-time situational awareness across the US power grid."
  banner_gradient: "linear-gradient(90deg, #f59e0b, #d97706)"
  footer_text: "Nationwide &bull; Low-cost FDRs &bull; GPS-synchronised &bull; Real-time"
  tags:
    - Distributed Sensing
    - Real-Time
  filters:
    sector: energy
    hazard: "natural organisational"
    location: usa

# Sections
sections:
  - id: overview
    icon_emoji: "&#x26A1;"
    content: |
      **FNET/GridEye** is a wide-area frequency monitoring system developed through academic-industry collaboration, originally at Virginia Tech and now maintained at the University of Tennessee, Knoxville. The network deploys low-cost Frequency Disturbance Recorders (FDRs) at ordinary power outlets across the United States, using GPS synchronisation to provide precise, time-stamped frequency measurements.

      Unlike traditional SCADA and PMU-based monitoring, FNET/GridEye offers a complementary, independently deployed sensing layer that captures grid-wide dynamics from the distribution level. It has proven valuable for detecting generation trips, load shedding events, islanding, and inter-area oscillations in near real-time.

  - id: timeline
    content: |
      **2003:** FNET concept developed at Virginia Tech. **2004&ndash;2008:** Initial FDR deployment across Eastern, Western, and ERCOT interconnections. **2009&ndash;present:** Expansion of sensor network, development of GridEye analytics platform, and ongoing research at University of Tennessee. Location: **United States (nationwide)**.

  - id: stakeholders
    content: |
      **University of Tennessee, Knoxville** as lead research institution. **Virginia Tech** as originating institution. **US Department of Energy** as funder. Electric utilities and ISOs/RTOs as data users. Power engineering research community internationally.

  - id: digitalisation
    content: |
      FNET/GridEye represents a digital innovation in power grid monitoring: low-cost FDR sensors connect to standard power outlets and use GPS receivers for time synchronisation. Data streams to a central server for real-time processing and visualisation through the GridEye platform.

      Key digital capabilities include: real-time frequency deviation detection, event triangulation and location estimation, inter-area oscillation monitoring, and historical event archival for post-event analysis and research.

  - id: hazards
    type: hazards
    exogenous: "Natural disasters (hurricanes, ice storms, earthquakes) causing generation loss and grid instability; extreme weather events increasing frequency of disturbances."
    endogenous: "Organisational challenges in data sharing between utilities and researchers; integration with existing SCADA/EMS systems; scaling sensor deployment and maintenance."

  - id: cost-benefit
    content: |
      **Cost:** Low per-unit sensor cost (FDRs use standard power outlets, no need for instrument transformers); moderate central infrastructure and analytics platform costs.

      **Benefit:** Provides independent, wide-area situational awareness complementing utility SCADA systems; enables rapid event detection and characterisation; supports research into grid dynamics and renewable integration; low barrier to deployment expansion.

  - id: principles
    type: principles
    assessments:
      - principle: "Continuously Learning (P1)"
        status: done
        content: "Post-event analysis and disturbance archival enable continuous learning about grid behaviour, failure modes, and system dynamics over time."
      - principle: "Proactively Protected (P2)"
        status: done
        content: "Early detection of abnormal frequency dynamics enables faster situational awareness and response to emerging grid disturbances."
      - principle: "Environmentally Integrated (P3)"
        status: todo
        content: "Environmental integration of frequency monitoring with renewable energy variability and climate impacts is an area for further development."
      - principle: "Socially Engaged (P4)"
        status: todo
        content: "Public engagement dimensions of grid monitoring and resilience are areas for further development."
      - principle: "Shared Responsibility (P5)"
        status: done
        content: "Academic-industry collaboration model enables shared development and knowledge exchange between universities, utilities, and government."
      - principle: "Adaptively Transforming (P6)"
        status: done
        content: "Low-cost sensor innovation enables wider coverage and democratises grid monitoring capability, supporting adaptive expansion as grid conditions evolve."

  - id: futures
    content: |
      FNET/GridEye continues to expand its sensor network and analytics capabilities. Future priorities include integration with increasing renewable generation variability monitoring, enhanced machine learning for automated event classification, and potential international expansion of the distributed sensing model. The low-cost, distribution-level approach offers a template for grid monitoring in developing regions.

# Related studies
related_studies:
  - slug: usa-wampac
    category: "Energy &bull; United States"
    title: "WAMPAC Grid Protection"
    desc: "Wide-area monitoring, protection, and control for power grid resilience."
    banner_gradient: "linear-gradient(90deg, #f59e0b, #d97706)"
  - slug: uk-credo
    category: "Digital &bull; United Kingdom"
    title: "CREDO Digital Twin"
    desc: "Connected digital twin for cross-sector infrastructure resilience."
    banner_gradient: "linear-gradient(90deg, #8b5cf6, #6d28d9)"

footer_text: "DIR Case Study Wiki &mdash; USA FNET/GridEye &bull; Last updated March 2026 &bull; <a href='https://github.com/visioninglab/DIRwiki/issues' style='color:var(--accent);text-decoration:none;'>Suggest an edit</a>"
---
