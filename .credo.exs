common_checks = [
  {Credo.Check.Consistency.ExceptionNames},
  {Credo.Check.Consistency.LineEndings},
  {Credo.Check.Consistency.SpaceAroundOperators},
  {Credo.Check.Consistency.SpaceInParentheses},
  {Credo.Check.Consistency.TabsOrSpaces},
  {Credo.Check.Design.AliasUsage, if_called_more_often_than: 2, if_nested_deeper_than: 1},
  {Credo.Check.Design.TagTODO},
  {Credo.Check.Design.TagFIXME},
  {Credo.Check.Readability.AliasOrder},
  {Credo.Check.Readability.FunctionNames},
  {Credo.Check.Readability.LargeNumbers},
  {Credo.Check.Readability.MaxLineLength, max_length: 200},
  {Credo.Check.Readability.ModuleAttributeNames},
  {Credo.Check.Readability.ModuleDoc, false},
  {Credo.Check.Readability.ModuleNames},
  {Credo.Check.Readability.MultiAlias},
  {Credo.Check.Readability.ParenthesesInCondition},
  {Credo.Check.Readability.PredicateFunctionNames},
  {Credo.Check.Readability.SinglePipe},
  {Credo.Check.Readability.StrictModuleLayout},
  {Credo.Check.Readability.TrailingBlankLine},
  {Credo.Check.Readability.TrailingWhiteSpace},
  {Credo.Check.Readability.VariableNames},
  {Credo.Check.Refactor.ABCSize, max_size: 40},
  {Credo.Check.Refactor.CaseTrivialMatches},
  {Credo.Check.Refactor.CondStatements},
  {Credo.Check.Refactor.FunctionArity},
  {Credo.Check.Refactor.MapInto, false},
  {Credo.Check.Refactor.MatchInCondition},
  {Credo.Check.Refactor.PipeChainStart, excluded_argument_types: ~w(atom binary fn keyword)a, excluded_functions: ~w(from)},
  {Credo.Check.Refactor.CyclomaticComplexity},
  {Credo.Check.Refactor.NegatedConditionsInUnless},
  {Credo.Check.Refactor.NegatedConditionsWithElse},
  {Credo.Check.Refactor.Nesting},
  {Credo.Check.Refactor.UnlessWithElse},
  {Credo.Check.Refactor.WithClauses},
  {Credo.Check.Warning.IExPry},
  {Credo.Check.Warning.IoInspect},
  {Credo.Check.Warning.LazyLogging, false},
  {Credo.Check.Warning.OperationOnSameValues},
  {Credo.Check.Warning.BoolOperationOnSameValues},
  {Credo.Check.Warning.UnusedEnumOperation},
  {Credo.Check.Warning.UnusedKeywordOperation},
  {Credo.Check.Warning.UnusedListOperation},
  {Credo.Check.Warning.UnusedStringOperation},
  {Credo.Check.Warning.UnusedTupleOperation},
  {Credo.Check.Warning.OperationWithConstantResult},
  {CredoEnvvar.Check.Warning.EnvironmentVariablesAtCompileTime},
  {CredoNaming.Check.Warning.AvoidSpecificTermsInModuleNames, terms: ["Manager", "Fetcher", "Builder", "Persister", "Serializer", ~r/^Helpers?$/i, ~r/^Utils?$/i]},
  {CredoNaming.Check.Consistency.ModuleFilename,
   excluded_paths: ["config", "mix.exs", "priv", "test/support"], acronyms: [{"ElixirBoilerplateGraphQL", "elixir_boilerplate_graphql"}, {"GraphQL", "graphql"}]}
]

%{
  configs: [
    %{
      name: "default",
      strict: true,
      files: %{
        included: ["*.exs", "lib/", "priv/", "config/", "rel/"],
        excluded: []
      },
      checks:
        common_checks ++
          [
            {Credo.Check.Design.DuplicatedCode, excluded_macros: []}
          ]
    },
    %{
      name: "test",
      strict: true,
      files: %{
        included: ["test/"],
        excluded: []
      },
      checks: common_checks
    }
  ]
}
