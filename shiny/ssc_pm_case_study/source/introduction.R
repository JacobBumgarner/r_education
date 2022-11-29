library(shiny)
library(shinydashboard)
library(shinydashboardPlus)


# Introduction tab
title <- fluidRow(box(
    title = tags$h2(
        HTML(
            "Case Report:<br>
            Diffuse Cutaneous Systemic Sclerosis and Polymyositis"
        ),
        align = "center"
        ),
    width = 12,
    height = "50%",
    tags$h4(
    HTML(
        "
    Diffuse Cutaneous Systemic Sclerosis and Polymyositis are two
    rare autoimmune diseases.
    <br>
    This case report examines the epidemiology and EU treatment network center
    locations for each disease.
        "
    ),
    align = "center"
)
))

dcssc_box <- box(
    title = "Diffuse Cutaneous Systemic Sclerosis",
    width = 12,
    height = 12,
    icon = icon("disease"),
    status = "warning",
    solidHeader = TRUE,
    collapsible = FALSE,
    tags$p(
        tags$h4(HTML("<b>Overview</b>")),
        HTML(
            "
            Diffuse cutaneous systemic sclerosis (dcSSc) is a form 
            systemic sclerosis, a rare autoimmune disease.
            <br>
            Patients with dcSSc often present with Raynaud's Phenomenon
            (finger discoloration), and skin hardening from excessive
            extracellular matrix protein deposition (e.g., collagen).
            "
        ),
        tags$h4(HTML("<b>Treatment & Prognosis</b>")),
        HTML(
            "
            There is currently no known treatment for dcSSc, but
            palliative treatments exist.
            <br>
            The 5-year survival rate for dcSSc is 85.5%, and the 10-year
            survival rate is 69.7% 
            <a target='_blank' href='https://arthritis-research.biomedcentral.com/articles/10.1186/s13075-021-02672-y'>[1]</a>.
            "
        ),
        tags$h4(HTML("<b>Pathophysiology</b>")),
        HTML(
            "
            dcSSc is characterized by disruption of the microvasculature,
            inflammation, and excessive fibrosis
            <a target='_blank' href='https://link.springer.com/article/10.1007/s10067-005-0041-0'>[2]</a>.

            <br>
            The exact physiological mechanisms of dcSSc are not
            well-characterized, but SSc is characterized by excessive
            infiltration of CD4+ & CD4+CD8+ T cells and monocytes into 
            the target tissue. The CD28/CD80-86 activational
            pathway is excessively active in this disease family
            <a target='_blank' href='https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4459100/'>[3]</a>.
            "
        )
    )
)

pm_box <- box(
    title = "Polymyositis",
    width = 12,
    height = 12,
    icon = icon("disease"),
    status = "warning",
    solidHeader = TRUE,
    collapsible = FALSE,
    tags$p(
        tags$h4(HTML("<b>Overview</b>")),
        HTML(
            "
            Polymyositis (PM) is a type of rare muscle diseases known 
            as inflammatory myopathies.
            <br>
            PM is an inflammatory disease that causes skeletal muscle 
            weakness (myopathy).
            <br>
            "
        ),
        tags$h4(HTML("<b>Treatment & Prognosis</b>")),
        HTML(
            "There is currently no known treatment for PM, but 
            palliative treatments exist.<br>
            The 5-year survival rate of PM is 75%, and the 10-year 
            survival rate is 55%
            <a target='_blank' href='https://pubmed.ncbi.nlm.nih.gov/16477398/'>[4]</a>.
            "
        ),
        tags$h4(HTML("<b>Pathophysiology</b>")),
        HTML(
            "PM is characterized by excessive muscular inflammation 
            caused by infiltrating CD4+ and CD8+ T cells, macrophages, 
            and dendritic cells into skeletal muscular tissue
            <a target='_blank' href='https://www.ncbi.nlm.nih.gov/books/NBK532860/#:~:text=The%20estimated%20prevalence%20of%20polymyositis,increase%20in%20the%20detection%20rate.'>[5]</a>.

            <br>

            The microvasculature of PM eventually thickens at the 
            capillary and venule level, leading to increased 
            inflammatory cell infiltration
            <a target='_blank' href='https://www.ncbi.nlm.nih.gov/books/NBK532860/#:~:text=The%20estimated%20prevalence%20of%20polymyositis,increase%20in%20the%20detection%20rate.'>[5]</a>.
            "
        )
    )
)

etiology_row <- fluidRow(column(6, dcssc_box), column(6, pm_box))

reference_header <- h3("References:")

references <- box(
    title = "References",
    icon = icon("book"),
    status = "black",
    width = 12,
    tags$ol(
        tags$li("De Almeida Chaves, S., Porel, T., Mounié, M., Alric, L., Astudillo, L., Huart, A., Lairez, O., Michaud, M., Prévot, G. & Ribes, D. (2021) Sine scleroderma, limited cutaneous, and diffused cutaneous systemic sclerosis survival and predictors of mortality. Arthritis research &amp; therapy. 23, 1-12."),
        tags$li("Ostojić, P. & Damjanov, N. (2006) Different clinical features in patients with limited and diffuse cutaneous systemic sclerosis. Clinical rheumatology. 25, 453-457."),
        tags$li("Pattanaik, D., Brown, M., Postlethwaite, B.C. & Postlethwaite, A.E. (2015) Pathogenesis of systemic sclerosis. Frontiers in Immunology. 6, 272."),
        tags$li("Airio, A., Kautiainen, H. & Hakala, M. (2006) Prognosis and mortality of polymyositis and dermatomyositis patients. Clinical rheumatology. 25, 234-239."),
        tags$li("Cheeti, A., Brent, L.H. & Panginikkod, S. (2022) Autoimmune myopathies. In StatPearls [Internet], StatPearls Publishing.")
    )
)

introduction_tab <- tabItem(
    tabName = "introduction",
    title,
    br(),
    etiology_row,
    br(),
    references
)
