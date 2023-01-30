
link_basename <- "https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc="

study_ids <- c(
    "GSE15602",
    "GSE24742",
    "GSE45867",
    "GSE65127",
    "GSE66321",
    "GSE68215",
    "GSE72326",
    "GSE78068",
    "GSE91079",
    "GSE112943",
    "GSE117769",
    "GSE148346",
    "GSE151161",
    "GSE172188"
)

metadata <- data.frame(
    study_id = character(),
    title = character(),
    summary = character(),
    publication_date = character(),
    link = character()
)

for (study_id in study_ids) {
    print(study_id)
    search_term <- paste0(study_id, "[ACCN] AND GSE[ETYP]")
    id <- rentrez::entrez_search(
        db = "gds",
        term = search_term
    )$id

    result <- rentrez::entrez_summary(db = "gds", id = id)
    data <- list(
        study_id,
        result$title,
        result$summary,
        result$pdat,
        paste0(link_basename, study_id)
    )

    metadata[nrow(metadata) + 1, ] <- data
}

arrow::write_parquet(metadata, "data/study_summaries.parquet")
