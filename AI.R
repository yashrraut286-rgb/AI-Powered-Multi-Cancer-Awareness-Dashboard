library(shiny)
library(shinydashboard)
library(plotly)
library(DT)

# ==========================================
# 1. ENHANCED DARK THEME (TAB CONTENT FIX)
# ==========================================
dark_css <- "
/* Base layouts */
.content-wrapper, .right-side, .main-sidebar {
  background-color: #121212 !important;
  color: #e0e0e0 !important;
}
.main-header .logo, .main-header .navbar {
  background-color: #1a1a1a !important;
}

/* Sidebar Styling */
.sidebar-menu > li.active > a, .sidebar-menu > li:hover > a {
  border-left-color: #00adb5 !important;
  background-color: #1e1e1e !important;
}
.sidebar-menu > li > a {
  color: #b3b3b3 !important;
}

/* TabBox Panel Configuration */
.box, .nav-tabs-custom, .nav-tabs-custom > .tab-content {
  background-color: #1e1e1e !important;
  color: #e0e0e0 !important;
  border-radius: 6px;
  border: none !important;
}

.nav-tabs-custom {
  border-top: 3px solid #00adb5 !important;
  box-shadow: 0 4px 6px rgba(0,0,0,0.3);
}

.nav-tabs-custom > .nav-tabs {
  background-color: #1a1a1a !important;
  border-bottom: 1px solid #333333 !important;
}

.nav-tabs-custom > .nav-tabs > li > a {
  color: #b3b3b3 !important;
  border-radius: 0 !important;
}

.nav-tabs-custom > .nav-tabs > li.active > a {
  background-color: #1e1e1e !important;
  color: #00adb5 !important;
  border-top-color: transparent !important;
  border-left-color: transparent !important;
  border-right-color: transparent !important;
  font-weight: bold;
}

/* Typography & Inputs */
h1, h2, h3, h4, h5, h6, p, label, .control-label {
  color: #ffffff !important;
}
.form-control, .selectize-input, .selectize-dropdown {
  background-color: #2a2a2a !important;
  color: #ffffff !important;
  border: 1px solid #444444 !important;
}

/* Slider Customizer Styling */
.irs-grid-text, .irs-min, .irs-max, .irs-single {
  color: #ffffff !important;
}
.irs-line {
  background-color: #333333 !important;
  border: 1px solid #444444 !important;
}
.irs-bar {
  background-color: #00adb5 !important;
}
.irs-slider {
  background-color: #ffffff !important;
  border: 1px solid #00adb5 !important;
}

/* CTA Evaluation Button */
.btn-assessment {
  background-color: #00adb5 !important;
  color: white !important;
  font-weight: bold;
  border: none;
  width: 100%;
  padding: 12px;
  font-size: 16px;
  border-radius: 4px;
  margin-top: 10px;
  transition: background 0.3s;
}
.btn-assessment:hover {
  background-color: #008c95 !important;
}
"

# ==========================================
# 2. USER INTERFACE
# ==========================================
ui <- dashboardPage(
  dashboardHeader(title = "AI Multi-Cancer Dashboard"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard Overview", tabName = "dashboard", icon = icon("chart-pie")),
      menuItem("Risk Assessment", tabName = "assessment", icon = icon("stethoscope")),
      menuItem("Awareness Center", tabName = "awareness", icon = icon("book-medical")),
      menuItem("Symptom Glossary", tabName = "glossary", icon = icon("list-check"))
    )
  ),
  
  dashboardBody(
    tags$head(tags$style(HTML(dark_css))),
    
    tabItems(
      # --- TAB 1: OVERVIEW ---
      tabItem(
        tabName = "dashboard",
        fluidRow(
          valueBoxOutput("vbox_count", width = 4),
          valueBoxOutput("vbox_symptoms", width = 4),
          valueBoxOutput("vbox_type", width = 4)
        ),
        fluidRow(
          box(
            width = 12, title = "🚨 Critical Medical Disclaimer", status = "danger", solidHeader = TRUE,
            HTML("
              <div style='padding: 5px;'>
                <h4><b>Educational Demonstration Platform Only</b></h4>
                <p>This software operates using simulated mock processing logic. It does <b>NOT</b> provide actual medical advice, diagnostic tracking, screening, or validated health reports.</p>
                <p style='color: #ff6b6b; font-weight: bold;'>Mandatory: Always consult a certified oncology professional or qualified physician for genuine clinical screenings or evaluation of physical symptoms.</p>
              </div>
            ")
          )
        ),
        fluidRow(
          box(width = 6, title = "Baseline Worldwide Oncological Incidences", plotlyOutput("global_chart")),
          box(width = 6, title = "Screening Tracking vs Early Identification Rates", plotlyOutput("trend_chart"))
        )
      ),
      
      # --- TAB 2: ASSESSMENT (WITH SYMPTOM VECTORS) ---
      tabItem(
        tabName = "assessment",
        fluidRow(
          box(
            width = 4, title = "Demographics & Vital Profile",
            textInput("p_name", "Patient Identifier/Name", placeholder = "Anonymous Patient"),
            numericInput("p_age", "Current Age", value = 40, min = 1, max = 120),
            selectInput("p_gender", "Biological Sex", choices = c("Male", "Female", "Other")),
            sliderInput("p_bmi", "Body Mass Index (BMI Value)", min = 15, max = 45, value = 23, step = 0.1)
          ),
          
          box(
            width = 8, title = "Symptom & Risk Matrix Evaluation (48 Risk Vectors Evaluated)",
            tabBox(
              width = 12,
              
              tabPanel("1. Lung Metrics",
                       fluidRow(
                         column(6, sliderInput("l_cough", "Persistent Dry/Productive Cough", 0,10,0)),
                         column(6, sliderInput("l_hemoptysis", "Hemoptysis (Coughing Blood)", 0,10,0)),
                         column(6, sliderInput("l_dyspnea", "Dyspnea (Shortness of Breath)", 0,10,0)),
                         column(6, sliderInput("l_chestpain", "Unexplained Chest Wall Pain", 0,10,0)),
                         column(6, sliderInput("l_smoking", "Smoking Duration & Intensity Index", 0,10,0)),
                         column(6, sliderInput("l_radon", "Asbestos/Radon Toxic Exposures", 0,10,0)),
                         column(6, sliderInput("l_hoarseness", "Vocal Cord Hoarseness Changes", 0,10,0)),
                         column(6, sliderInput("l_wheezing", "Stridor / Wheezing Respiration", 0,10,0))
                       )
              ),
              
              tabPanel("2. Breast Metrics",
                       fluidRow(
                         column(6, sliderInput("b_lump", "Palpable Breast Tissue Lump", 0,10,0)),
                         column(6, sliderInput("b_dimpling", "Skin Dimpling (Peau d'orange)", 0,10,0)),
                         column(6, sliderInput("b_nipple", "Nipple Inversion / Retraction", 0,10,0)),
                         column(6, sliderInput("b_discharge", "Spontaneous Fluid Discharge", 0,10,0)),
                         column(6, sliderInput("b_brca", "BRCA1 / BRCA2 Genetic Markers", 0,10,0)),
                         column(6, sliderInput("b_axillary", "Axillary Lymph Node Swelling", 0,10,0)),
                         column(6, sliderInput("b_erythema", "Breast Skin Erythema / Heat", 0,10,0)),
                         column(6, sliderInput("b_density", "Mammographic Density Baseline", 0,10,0))
                       )
              ),
              
              tabPanel("3. Oral Metrics",
                       fluidRow(
                         column(6, sliderInput("o_ulcer", "Mouth Ulcers Non-healing >3 Wks", 0,10,0)),
                         column(6, sliderInput("o_leuko", "Leukoplakia White/Red Patches", 0,10,0)),
                         column(6, sliderInput("o_dysphagia", "Dysphagia (Difficulty Swallowing)", 0,10,0)),
                         column(6, sliderInput("o_tobacco", "Chewing Tobacco / Betel Nut Use", 0,10,0)),
                         column(6, sliderInput("o_pain", "Persistent Tongue or Jaw Discomfort", 0,10,0)),
                         column(6, sliderInput("o_numb", "Oral Tissue Loss of Sensation", 0,10,0)),
                         column(6, sliderInput("o_loose", "Unexplained Loosening of Teeth", 0,10,0)),
                         column(6, sliderInput("o_hpv", "HPV-16/18 Infection Exposure", 0,10,0))
                       )
              ),
              
              tabPanel("4. Liver Metrics",
                       fluidRow(
                         column(6, sliderInput("li_jaundice", "Scleral Icterus / Jaundice Skin", 0,10,0)),
                         column(6, sliderInput("li_ascites", "Abdominal Ascites Fluid Retention", 0,10,0)),
                         column(6, sliderInput("li_ruq", "Right Upper Quadrant (RUQ) Pain", 0,10,0)),
                         column(6, sliderInput("li_alcohol", "Chronic Heavy Alcohol Usage Profile", 0,10,0)),
                         column(6, sliderInput("li_hep", "Chronic Hepatitis B / C Carrier", 0,10,0)),
                         column(6, sliderInput("li_pruritus", "Severe Generalized Skin Pruritus", 0,10,0)),
                         column(6, sliderInput("li_cirrhosis", "Diagnosed Cirrhosis Severity", 0,10,0)),
                         column(6, sliderInput("li_hepatomeg", "Palpable Liver Swelling Mass", 0,10,0))
                       )
              ),
              
              tabPanel("5. Colorectal Metrics",
                       fluidRow(
                         column(6, sliderInput("c_copy", "Hematochezia (Rectal Bleeding)", 0,10,0)),
                         column(6, sliderInput("c_habit", "Altered Habits (Diarrhea/Constip)", 0,10,0)),
                         column(6, sliderInput("c_tenesmus", "Bowel Tenesmus / Fullness", 0,10,0)),
                         column(6, sliderInput("c_anemia", "Iron Deficiency Anemia Severity", 0,10,0)),
                         column(6, sliderInput("c_polyps", "History of Adenoma Polyps", 0,10,0)),
                         column(6, sliderInput("c_ibd", "Active IBD (Colitis or Crohn's)", 0,10,0)),
                         column(6, sliderInput("c_stool", "Narrow Caliber Pencil-Thin Stool", 0,10,0)),
                         column(6, sliderInput("c_diet", "High Processed Red Meat Intake", 0,10,0))
                       )
              ),
              
              tabPanel("6. Prostate/Ovarian Metrics",
                       fluidRow(
                         column(6, sliderInput("g_dysuria", "Dysuria / Weak Urinary Stream", 0,10,0)),
                         column(6, sliderInput("g_nocturia", "Severe Frequency / Nocturia Spikes", 0,10,0)),
                         column(6, sliderInput("g_pelvic", "Chronic Pelvic Dull Aching Pain", 0,10,0)),
                         column(6, sliderInput("g_bloating", "Persistent Abdominal Bloating", 0,10,0)),
                         column(6, sliderInput("g_satiety", "Early Satiety / Rapid Fullness", 0,10,0)),
                         column(6, sliderInput("g_hematuria", "Hematuria (Blood in Urine)", 0,10,0)),
                         column(6, sliderInput("g_psa", "Elevated Baseline Serum PSA", 0,10,0)),
                         column(6, sliderInput("g_menarche", "Nulliparous / Early Menarche", 0,10,0))
                       )
              )
            )
          )
        ),
        
        fluidRow(
          column(12, actionButton("predict", "Execute Multi-Cancer Pattern Evaluation", class = "btn-assessment"))
        ),
        br(),
        fluidRow(
          box(
            width = 12, title = "Evaluation Output Metrics & Percentages",
            verbatimTextOutput("result_summary"),
            plotlyOutput("assessment_chart")
          )
        )
      ),
      
      # --- TAB 3: AWARENESS CENTER (DETAILED PARAGRAPHS ADDED) ---
      tabItem(
        tabName = "awareness",
        h2("Oncology Information & Education Repository"),
        p("Explore detailed, multi-paragraph educational insights on major cancer categories, focusing on diagnostic paths, risk variables, and clinical guidelines."),
        br(),
        tabBox(
          width = 12,
          tabPanel("Lung Cancer", 
                   h3("Lung Oncology Insights & Pathophysiology"),
                   p("Lung cancer stands as the leading cause of oncological mortality worldwide, cutting across various demographic boundaries. While long-term tobacco use is responsible for approximately 85% of cases, non-smokers remain vulnerable due to environmental and genetic interactions. Exposure to industrial hazards such as asbestos, radon gas leaks in residential basements, and heavy ambient air pollution can induce severe epithelial mutations over extended decades."),
                   p("Early-stage lung malignancies are famously asymptomatic, often mimicking a lingering cold or seasonal allergy. By the time structural flags like hemoptysis (coughing up blood), localized chest wall pain, or vocal cord hoarseness manifest, the disease has often advanced. Medical guidelines strongly advise individuals aged 50 to 80 with a substantial smoking history to undergo annual Low-Dose Computed Tomography (LDCT) scans, which can detect early cellular nodules and drastically drop global mortality rates.")),
          
          tabPanel("Breast Cancer", 
                   h3("Breast Oncology Screenings & Risk Management"),
                   p("Breast cancer represents one of the most common cancer diagnoses among women globally, though it can also occur in men. The pathology is highly linked to total lifetime estrogen exposure, which can be influenced by factors such as early menarche, late menopause, or nulliparity. Furthermore, inherited genetic variants—most notably mutations within the BRCA1 and BRCA2 tumor suppressor genes—markedly escalate an individual's lifetime risk profile, necessitating customized early clinical monitoring protocols."),
                   p("Clinical long-term survival metrics depend heavily on timely anatomical localization. Routine screening mammograms, typically recommended to begin between ages 40 and 45, can spot deep calcifications well before they form a palpable mass. Individuals are urged to seek prompt clinical evaluations if they note physical signs such as a hard, fixed tissue lump, spontaneous clear or bloody nipple discharge, localized skin dimpling resembling an orange peel (peau d'orange), or unexplained axillary lymph node swelling.")),
          
          tabPanel("Oral Cancer", 
                   h3("Oral Cavity Carcinomas & Synergistic Hazards"),
                   p("Oral squamous cell carcinomas encompass malignancies originating anywhere within the lips, interior gingiva, buccal mucosa, tongue base, or the hard and soft palates. Historically, this category has been driven by the heavy, combined usage of combustible tobacco products and high-proof alcohol. When used concurrently, alcohol acts as a solvent, enhancing mucosal permeability and allowing the specialized carcinogens in tobacco to easily alter deep epithelial DNA."),
                   p("In recent years, the medical community has observed a rise in oral cancers linked to high-risk human papillomavirus strains, specifically HPV-16 and HPV-18. Early physical warnings frequently include persistent, non-healing ulcers that last beyond three weeks, unusual loose teeth unlinked to standard periodontitis, or distinct velvety red patches (erythroplakia) and thick white plaques (leukoplakia). Routine dental checkups provide a vital first line of defense for visual and physical screening.")),
          
          tabPanel("Liver Cancer", 
                   h3("Hepatocellular Carcinoma & Hepatic Fibrosis"),
                   p("Primary liver cancer, most frequently presenting as Hepatocellular Carcinoma (HCC), is a aggressive malignancy that almost always builds upon a long-standing foundation of parenchymal liver damage. Chronic infections from Hepatitis B (HBV) or Hepatitis C (HCV) lead to continuous cellular turnover and DNA duplication errors. This risk is further heightened by lifestyle factors, such as chronic alcohol abuse and the rise of metabolic dysfunction-associated steatotic liver disease (MASLD)."),
                   p("Because the liver has a large functional reserve, tumors can expand significantly before causing observable symptoms. When physical changes like visible jaundice (scleral icterus), abdominal fluid accumulation (ascites), or severe right upper quadrant pain appear, it often indicates advanced structural progression. For patients with known cirrhosis or chronic viral hepatitis, professional guidelines recommend lifelong monitoring via biannual hepatic ultrasounds paired with serum alpha-fetoprotein (AFP) checks.")),
          
          tabPanel("Colorectal Cancer", 
                   h3("Colorectal Adenocarcinomas & Mucosal Screening"),
                   p("Colorectal cancer typically develops through a slow, progressive sequence, starting as benign adenomatous polyps on the mucosal lining of the large intestine or rectum before accumulating malignant mutations over 10 to 15 years. This long development window makes it highly preventable. Key lifestyle risks include chronic low-fiber diets high in ultra-processed red meats, sedentary behavior, and chronic gut inflammation from conditions like Ulcerative Colitis or Crohn's disease."),
                   p("Early screening remains critical. Standard medical guidelines recommend starting screening at age 45 using options like non-invasive Fecal Immunochemical Tests (FIT) or direct visual colonoscopies. Warning signs that require immediate clinical investigation include persistent changes in bowel habits (such as alternating diarrhea and constipation), pencil-thin stool caliber caused by structural blockages, unexplained rectal bleeding, and microcytic iron-deficiency anemia in adult males or postmenopausal women.")),
          
          tabPanel("Prostate/Ovarian", 
                   h3("Genitourinary & Reproductive Tract Malignancies"),
                   p("This specialized category combines critical tracking for site-specific male and female reproductive organ systems. Prostate cancer is typically a slow-progressing condition driven by androgen pathways in aging men, often detected early through routine Prostate-Specific Antigen (PSA) blood tests. Conversely, ovarian cancer is often referred to as a 'silent killer' because it lacks specific early symptoms, frequently evading detection until it has spread across the peritoneal cavity."),
                   p("Advanced prostate changes typically present as lower urinary tract symptoms, including severe nocturia, urinary hesitancy, a weak stream, or macro-hematuria. Ovarian malignancies often manifest through subtle, vague indicators like persistent abdominal bloating, early satiety (feeling full rapidly after eating very little), and deep pelvic fullness. Individuals experiencing these subtle symptoms continuously for several weeks should consult a physician for a transvaginal ultrasound and biomarker evaluation."))
        )
      ),
      
      # --- TAB 4: GLOSSARY ---
      tabItem(
        tabName = "glossary",
        h2("Searchable Symptom Index Database"),
        br(),
        box(width = 12, DTOutput("glossary_table"))
      )
    )
  )
)

# ==========================================
# 3. SERVER LOGIC
# ==========================================
server <- function(input, output, session) {
  
  # Welcome Disclaimer Modal Dialog
  observe({
    showModal(modalDialog(
      title = "⚠️ STRICT MEDICAL DISCLAIMER & LIABILITY NOTICE",
      HTML("<p>This platform serves exclusively as an interactive education toolkit dashboard interface.</p>
            <p>It does <b>NOT</b> replace diagnostic screening, clinical analysis, or medical treatment plans.</p>"),
      easyClose = FALSE,
      footer = modalButton("I Expressly Acknowledge & Agree")
    ))
  })
  
  # Reactive Value Boxes (UPDATED LABELS)
  output$vbox_count    = renderValueBox({ valueBox("6 Profiles", "Cancer Categories", icon = icon("virus-cancer"), color = "teal") })
  output$vbox_symptoms = renderValueBox({ valueBox("48 Profiles", "Assessment Parameters", icon = icon("sliders"), color = "purple") })
  output$vbox_type     = renderValueBox({ valueBox("Active", "Awareness Platform", icon = icon("circle-check"), color = "blue") })
  
  # Static Background Charts
  output$global_chart <- renderPlotly({
    plot_ly(x = c("Lung", "Breast", "Colorectal", "Prostate", "Liver", "Oral/Other"), y = c(2.2, 2.3, 1.9, 1.4, 0.9, 0.5), type = "bar", marker = list(color = "#00adb5")) %>%
      layout(plot_bgcolor = "#1e1e1e", paper_bgcolor = "#1e1e1e", font = list(color = "#ffffff"))
  })
  
  output$trend_chart <- renderPlotly({
    plot_ly() %>%
      add_lines(x = 2020:2025, y = c(45, 48, 52, 55, 60, 65), name = "Screening Rates %", line = list(color = "#ff6b6b")) %>%
      add_lines(x = 2020:2025, y = c(55, 57, 59, 61, 64, 68), name = "Early Detection %", line = list(color = "#00adb5")) %>%
      layout(plot_bgcolor = "#1e1e1e", paper_bgcolor = "#1e1e1e", font = list(color = "#ffffff"))
  })
  
  # Risk Engine Scoring Matrix (Outputs Exact Round Percentages)
  calculated_risks <- eventReactive(input$predict, {
    lung_score   <- sum(input$l_cough, input$l_hemoptysis, input$l_dyspnea, input$l_chestpain, input$l_smoking, input$l_radon, input$l_hoarseness, input$l_wheezing)
    breast_score <- sum(input$b_lump, input$b_dimpling, input$b_nipple, input$b_discharge, input$b_brca, input$b_axillary, input$b_erythema, input$b_density)
    oral_score   <- sum(input$o_ulcer, input$o_leuko, input$o_dysphagia, input$o_tobacco, input$o_pain, input$o_numb, input$o_loose, input$o_hpv)
    liver_score  <- sum(input$li_jaundice, input$li_ascites, input$li_ruq, input$li_alcohol, input$li_hep, input$li_pruritus, input$li_cirrhosis, input$li_hepatomeg)
    colorectal_score <- sum(input$c_copy, input$c_habit, input$c_tenesmus, input$c_anemia, input$c_polyps, input$c_ibd, input$c_stool, input$c_diet)
    genital_score <- sum(input$g_dysuria, input$g_nocturia, input$g_pelvic, input$g_bloating, input$g_satiety, input$g_hematuria, input$g_psa, input$g_menarche)
    
    max_score <- 80 # 8 sliders * max value 10
    
    # Return as clean, rounded percentages
    c(
      Lung = round((lung_score / max_score) * 100),
      Breast = round((breast_score / max_score) * 100),
      Oral = round((oral_score / max_score) * 100),
      Liver = round((liver_score / max_score) * 100),
      Colorectal = round((colorectal_score / max_score) * 100),
      Genitourinary = round((genital_score / max_score) * 100)
    )
  }, ignoreNULL = FALSE)
  
  # Summary Report Output with Text Percentages Added
  output$result_summary <- renderText({
    p_id <- if(input$p_name == "") "Unspecified Profile" else input$p_name
    p_age_display <- if(is.na(input$p_age)) "Not Provided" else input$p_age
    scores <- calculated_risks()
    
    paste0(
      "Comprehensive Simulation Log: ", p_id, " [Age: ", p_age_display, ", Sex: ", input$p_gender, "]\n",
      "Calculated Index Matrix: All 48 structural vectors processed successfully.\n\n",
      "--- SIMULATED PATTERN RISK MATRIX BREAKDOWN ---\n",
      " Lung Cancer: ", scores["Lung"], "%\n",
      " Breast Cancer: ", scores["Breast"], "%\n",
      " Oral Cancer: ", scores["Oral"], "%\n",
      " Liver Cancer: ", scores["Liver"], "%\n",
      " Colorectal Cancer: ", scores["Colorectal"], "%\n",
      " Genitourinary Cancer: ", scores["Genitourinary"], "%\n\n",
      "Status: Evaluation Completed. View interactive bar map below."
    )
  })
  
  # Assessment Chart with Interactive Percentage Labels Feature Enabled
  output$assessment_chart <- renderPlotly({
    scores <- calculated_risks()
    
    plot_ly(
      x = names(scores), 
      y = scores, 
      type = "bar", 
      text = paste0(scores, "%"),         # FEATURE: Add percentages directly onto bars
      textposition = "auto",              # Auto position labels neatly inside or on top of bars
      textfont = list(color = "#ffffff", font_weight = "bold"),
      marker = list(color = c("#ff6b6b", "#00adb5", "#f8b500", "#ab47bc", "#4caf50", "#007bff"))
    ) %>%
      layout(
        plot_bgcolor = "#1a1a1a", 
        paper_bgcolor = "#1e1e1e", 
        font = list(color = "#ffffff"), 
        yaxis = list(title = "Calculated Value Index Scale (%)", range = c(0, 110)) # Max 110 to give space for labels
      )
  })
  
  # Dictionary Data Table Output
  output$glossary_table <- renderDT({
    glossary_data <- data.frame(
      Symptom_Vector = c("Persistent Cough", "Hemoptysis", "Dyspnea", "Chest Pain", "Palpable Lump", "Skin Dimpling", "Nipple Discharge", "Mouth Ulcer", "Leukoplakia", "Dysphagia", "Jaundice", "Ascites", "RUQ Pain", "Hematochezia", "Narrow Stool", "Dysuria", "PSA Levels", "Abdominal Bloating"),
      Category = c(rep("Lung", 4), rep("Breast", 3), rep("Oral", 3), rep("Liver", 3), rep("Colorectal", 2), rep("Prostate/Ovarian", 3)),
      Clinical_Context = c("Cough extending past 3 weeks.", "Expectorating structural blood tracks.", "Shortness of breath.", "Continuous deep local thoracic pain.", "Hard fixed non-tender tissue mass.", "Skin cratering appearance.", "Spontaneous abnormal fluid leakage.", "Intraoral mucosal lesions.", "White/red non-scrapeable fixed film.", "Impairment when swallowing.", "Bilirubin tinting tissues yellow.", "Peritoneal fluid collection.", "Right Upper Quadrant pain.", "Rectal bleeding markers.", "Pencil-thin stool formations.", "Pain during micturition loops.", "Prostate biomolecule monitoring.", "Persistent core pelvic distension.")
    )
    datatable(glossary_data, options = list(pageLength = 5), rownames = FALSE) %>%
      formatStyle(columns = 1:3, color = "#ffffff", backgroundColor = "#1e1e1e")
  })
}

# Run Application
shinyApp(ui, server)
