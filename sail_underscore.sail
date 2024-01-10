  with(
    local!matches: if(
      len(
        ri!filter
      ) > 50,
      "",
      where(
        apply(
          search(
            ri!filter,
            _
          ),
          ri!labels
        )
      )
    ),
    'type!{http://www.appian.com/ae/types/2009}DataSubset'(
      data: index(
        ri!labels,
        local!matches,
        {}
      ),
      identifiers: index(
        ri!identifiers,
        local!matches,
        {}
      )
    )
   )
    