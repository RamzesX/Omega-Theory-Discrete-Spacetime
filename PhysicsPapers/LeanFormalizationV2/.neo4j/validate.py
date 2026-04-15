#!/usr/bin/env python3
"""Validate the loaded graph with representative queries."""
from neo4j import GraphDatabase

driver = GraphDatabase.driver('bolt://localhost:7687', auth=('neo4j', 'omegatheory2026'))

tests = [
    ('All axioms with their files', """
        MATCH (a:Axiom {namespace:'OmegaTheoryV2'})
        OPTIONAL MATCH (f:LeanFile)-[:DECLARES]->(a)
        RETURN a.name AS axiom, a.category AS cat, f.path AS file
        ORDER BY cat, a.name
    """),
    ('HPW consumer chain preserved', """
        MATCH (t:Theorem {namespace:'OmegaTheoryV2'})-[:USES_AXIOM|USES_THEOREM*1..3]->(a:Axiom {name:'hpw_laplacian_ricci_convergence'})
        RETURN DISTINCT t.name AS theorem, t.file AS file
        ORDER BY t.name
    """),
    ('Files importing LaplacianRicci.lean', """
        MATCH (src:LeanFile)-[:IMPORTS]->(dst:LeanFile {path:'OmegaTheory/Emergence/LaplacianRicci.lean'})
        RETURN src.path AS consumer
        ORDER BY src.path
    """),
    ('Files with most declarations', """
        MATCH (f:LeanFile {namespace:'OmegaTheoryV2'})
        RETURN f.path AS path, f.declarations_count AS decls
        ORDER BY decls DESC
        LIMIT 10
    """),
    ('Layer declaration counts', """
        MATCH (e:EntityNavigator {namespace:'OmegaTheoryV2'})-[:CONTAINS]->(f:LeanFile)
        RETURN e.name AS layer, count(f) AS files, sum(f.declarations_count) AS declarations
        ORDER BY declarations DESC
    """),
    ('Cross-file collision check', """
        MATCH (t:Theorem {namespace:'OmegaTheoryV2'})
        WITH t.name AS name, collect(DISTINCT t.file) AS files
        WHERE size(files) > 1
        RETURN name, files
    """),
    ('Importers of Geometry/PoincareLemma.lean', """
        MATCH (src:LeanFile)-[:IMPORTS]->(dst:LeanFile {path:'OmegaTheory/Geometry/PoincareLemma.lean'})
        RETURN src.path AS consumer
        ORDER BY src.path
    """),
    ('Definitions by kind', """
        MATCH (d:Definition {namespace:'OmegaTheoryV2'})
        RETURN d.kind AS kind, count(*) AS n
        ORDER BY n DESC
    """),
    ('einstein_with_matter_emergence still has its HPW chain relationships', """
        MATCH (t:Theorem {name:'einstein_with_matter_emergence', namespace:'OmegaTheoryV2'})
        OPTIONAL MATCH (t)-[r]->(other)
        RETURN t.is_flagship AS flagship, t.file AS file, type(r) AS rel, other.name AS target
    """),
]

with driver.session() as session:
    for label, q in tests:
        print(f'\n=== {label} ===')
        recs = list(session.run(q))
        if not recs:
            print('  (no results)')
        for rec in recs[:25]:
            print(f'  {dict(rec)}')
        if len(recs) > 25:
            print(f'  ... {len(recs) - 25} more')

driver.close()
