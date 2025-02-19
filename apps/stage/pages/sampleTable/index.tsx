import SampleTable from '@/components/pages/explorationTables/sampleTable';
import { createPage } from '@/global/utils/pages';

const SamplePage = createPage({
	getInitialProps: async ({ query, egoJwt }) => {
		return { query, egoJwt };
	},
	isPublic: true,
})(() => {
	return <SampleTable />;
});

export default SamplePage;
