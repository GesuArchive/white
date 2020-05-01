import { useBackend } from '../backend';
import { Button, LabeledList, NumberInput, Section } from '../components';
import { Window } from '../layouts';

export const BoomBox = (props, context) => {
	const { act, data } = useBackend(context);
	return (
		<Window>
			<Window.Content scrollable>
				<Section title="взрыв каробка">
					<LabeledList>
						<LabeledList.Item>
								<Button
									content={data.active ? "СТАРТ" : "СТОП"}
									onClick={() => act('toggle')} />
						</LabeledList.Item>

						<LabeledList.Item>
								<Button
									content='Выбрать трек'
									onClick={() => act('select')} />
						</LabeledList.Item>

						<LabeledList.Item label="Громкость">
								<NumberInput
									value={data.volume}
									unit="%"
									width="59px"
									minValue={0}
									maxValue={100}
									step={1}
									stepPixelSize={1}
									onChange={(e, value) => act('change_volume', {
										volume: value,
									})} />
						</LabeledList.Item>

						<LabeledList.Item>
							<Button
								content={data.env ? "Объемный звук ВКЛ" : "Объемный звук ВЫКЛ"}
								onClick={() => act('env')} />
						</LabeledList.Item>

						<LabeledList.Item
							buttons={!!data.disk && (
								<Button
									content="Изъять диск"
									disabled={!data.disk}
									onClick={() => act('eject')} />
								)}>
						</LabeledList.Item>

					</LabeledList>
				</Section>
			</Window.Content>
		</Window>
	);
};
